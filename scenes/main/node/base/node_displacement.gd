class_name NodeDisplacement
extends RigidBody2D

@export var long_press_delay_ms = 100
@export var attraction_factor = 0.1

var handler: NodeHandler

var dragging := false
var drag_initiated := false
var drag_index := -1
var timer_start := 0

var target_position := Vector2(0, 0)
var offset := Vector2(0, 0)
var initial_drag_position := Vector2(0, 0)

func _ready():
	handler = find_parent("Node Handler")
	assert(handler != null, "Node should be in a node Handler")

func set_target_from_drag(point: Vector2):
	target_position = point - $Control.size / 2 + offset

func _input(event):
	if event is InputEventScreenTouch:
		if (event.pressed and !drag_initiated):
			initiate_drag(event)
		if (!event.pressed and event.index == drag_index):
			cancel_drag(true)

	if event is InputEventScreenDrag and event.index == drag_index:
		if (dragging):
			var touch_position = Util.screen_to_world(get_viewport(), event.position)
			target_position = touch_position - $Control.size / 2 + offset
		elif (event.position.distance_to(initial_drag_position) > 10):
			cancel_drag(false)

func initiate_drag(event: InputEventScreenTouch):
	var touch_position = Util.screen_to_world(get_viewport(), event.position)
	
	if !is_point_inside_capsule(
			to_local(touch_position),
			$CollisionShape2D.shape,
			$CollisionShape2D.position
		): return

	# Initiate the drag
	target_position = touch_position - $Control.size / 2

	initial_drag_position = event.position

	# Get intial offset
	offset = global_position - target_position

	target_position += offset

	drag_initiated = true
	drag_index = event.index
	timer_start = Time.get_ticks_msec()

func cancel_drag(a):
	if a and drag_initiated and Time.get_ticks_msec() - timer_start < long_press_delay_ms  and !CameraMovement.control_locks.has("knob-manager/" + str(drag_index)):
		# NodeHandler.speed_up_factor += 1
		if(CameraMovement.control_locks.is_empty()):
			get_node("/root/root/CanvasLayer/VBoxContainer/Main/UpgradeMenu").open(owner)

	drag_initiated = false
			
	dragging = false
	CameraMovement.control_locks.erase("NodeDisplacement/" + str(drag_index))
	drag_index = -1

func _integrate_forces(delta):
	if (dragging):
		PhysicsServer2D.body_set_state(
			get_rid(),
			PhysicsServer2D.BODY_STATE_TRANSFORM,
			Transform2D.IDENTITY.translated(target_position)
		)
	else:
		if (global_position.length() > 4000):
			set_axis_velocity(global_position * - attraction_factor * delta.step)

func _process(_delta):
	get_parent().data.position = position
	
	if (!dragging and drag_initiated and Time.get_ticks_msec() - timer_start >= long_press_delay_ms and !CameraMovement.control_locks.has("knob-manager/" + str(drag_index))):
		# Start the drag
		CameraMovement.control_locks.append("NodeDisplacement/" + str(drag_index))
		dragging = true
	
	if (dragging): 
		$Control.scale = Vector2(1.1, 1.1)
		if $"../../.." is not CanvasLayer:
			var new_parent = $"../../../CanvasLayer"
			$"../../..".remove_child($"../..")
			new_parent.add_child($"../..")
	else: 
		$Control.scale = Vector2(1, 1)
		if $"../../.." is CanvasLayer:
			var new_parent = $"../../../.."
			$"../../..".remove_child($"../..")
			new_parent.add_child($"../..")

	get_parent().refreshLines()

func is_point_inside_capsule(point: Vector2, capsule_shape: CapsuleShape2D, capsule_position: Vector2) -> bool:
	var half_height = capsule_shape.height / 4.0
	var radius = capsule_shape.radius * 0.9

	# Calculate the positions of the two hemispheres
	var left_center = capsule_position + Vector2( - half_height, 0)
	var right_center = capsule_position + Vector2(half_height, 0)

	# Check if the point is inside the top hemisphere
	if point.distance_to(left_center) <= radius:
		return true

	# Check if the point is inside the bottom hemisphere
	if point.distance_to(right_center) <= radius:
		return true

	var top_left = left_center + Vector2(0, -half_height * 0.9)
	var bottom_right = right_center + Vector2(0, half_height * 0.9)
	
	# Check if the point is inside the cylindrical part
	if point.x >= top_left.x and point.x <= bottom_right.x and point.y >= top_left.y and point.y <= bottom_right.y:
		return true

	return false
