extends RigidBody2D

@export var long_press_delay_ms = 300
@export var attraction_factor = 0.1

var handler: NodeHandler

var dragging := false
var press_initiated := false
var press_index := 0
var timer_start := 0

var target_position := Vector2(0, 0)
var offset := Vector2(0, 0)

# TODO: Take initial offset into account

func _ready():
	handler = find_parent("Node Handler")
	assert(handler != null, "Node should be in a node Handler")


func _input(event):
	if event is InputEventScreenTouch:
		if (event.pressed and !press_initiated):
			var transformer = get_viewport().get_canvas_transform().affine_inverse()
			var touch_position = (event.position / handler.cam.zoom.x + transformer.origin)
			
			if is_point_inside_capsule(
				to_local(touch_position),
				 $CollisionShape2D.shape,
				 $CollisionShape2D.position):
				# Initiate the drag
				target_position = touch_position  - $Control.size / 2

				# Get intial offset
				offset = global_position - target_position

				target_position += offset

				press_initiated = true
				press_index = event.index
				timer_start = Time.get_ticks_msec()

		if (!event.pressed and event.index == press_index):
			press_initiated = false
			
			dragging = false
			press_index = -1
			
			handler.cam.control_enabled = true
	if event is InputEventScreenDrag:
		if (dragging and event.index == press_index):
			var transformer = get_viewport().get_canvas_transform().affine_inverse()
			var touch_position = (event.position / handler.cam.zoom.x + transformer.origin)
			target_position = touch_position - $Control.size / 2 + offset

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
	if (!dragging and press_initiated and Time.get_ticks_msec() - timer_start >= long_press_delay_ms):
		# Start the drag
		
		handler.cam.control_enabled = false
		dragging = true
	
	if (dragging): $Control.scale = Vector2(1.1, 1.1)
	else: $Control.scale = Vector2(1, 1)

func is_point_inside_capsule(point: Vector2, capsule_shape: CapsuleShape2D, capsule_position: Vector2) -> bool:
	#print(point, " ", capsule_position)
	var half_height = capsule_shape.height / 4.0
	var radius = capsule_shape.radius * 0.9

	# Calculate the positions of the two hemispheres
	var left_center = capsule_position + Vector2( -half_height, 0)
	var right_center = capsule_position + Vector2(half_height, 0)

	# Check if the point is inside the top hemisphere
	if point.distance_to(left_center) <= radius:
		print(Time.get_ticks_msec(), "left")
		return true

	# Check if the point is inside the bottom hemisphere
	if point.distance_to(right_center) <= radius:
		print(Time.get_ticks_msec(), "right")
		return true

	var top_left = left_center + Vector2(0, -half_height * 0.9)
	var bottom_right = right_center + Vector2(0, half_height * 0.9)
	
	# Check if the point is inside the cylindrical part
	if point.x >= top_left.x and point.x <= bottom_right.x and point.y >= top_left.y and point.y <= bottom_right.y:
		print(Time.get_ticks_msec(), "cyl")
		return true

	return false
