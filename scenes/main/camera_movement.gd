class_name CameraMovement

extends Camera2D


static var control_locks := []

@export var dampening := 0.8
@export var MAX_CAM_SPEED := 1000

@export var dragging := false

var intitialCameraPos := Vector2(0, 0)
var velocity := Vector2(0, 0)
var initialZoom := 1.0

var points: Dictionary
var dirty = false

func reset_points_origin():
	for id in points:
		points[id][0] = points[id][1]

func is_locked():
	if control_locks.size() > 0:
		return true
	else:
		return false

func _input(event):
	if event is InputEventMouseButton:
		# Scroll
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= Vector2(1.05, 1.05)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom /= Vector2(1.05, 1.05)
	if event is InputEventScreenTouch:
		if event.pressed:
			# Started a press
			Engine.physics_ticks_per_second = 60 * 4
			
			points[event.index] = [Vector2(0, 0), Vector2(0, 0)]
			points[event.index][0] = event.position
			points[event.index][1] = event.position
			
			if points.size() == 1: # Start one finger gesture
				intitialCameraPos = offset
			elif points.size() == 2: # Start two finger gesture
				reset_points_origin() # Reset the other point
				intitialCameraPos = offset
				initialZoom = zoom.x
		else:
			points.erase(event.index)
			if points.size() == 1: # Start one finger gesture
				intitialCameraPos = offset
				reset_points_origin()
			elif points.size() == 0:
				# Ended drag, enter velocity phase
				dragging = false
				Engine.physics_ticks_per_second = 60
				intitialCameraPos = offset
				
	elif event is InputEventScreenDrag:
		handle_drag(event)
	
	if zoom.length() > 2.5:
		var v = sqrt(2.5 ** 2 / 2)
		zoom = Vector2(v, v)
	elif zoom.length() < 0.5:
		var v = sqrt(0.5 ** 2 / 2)
		zoom = Vector2(v, v)

func _process(delta: float) -> void:
	$"../Node Handler/CanvasLayer".transform = get_canvas_transform()

func _physics_process(delta):
	if is_locked(): return
	if velocity != Vector2(0, 0) and points.size() == 0:
		velocity *= pow(dampening, delta * Engine.physics_ticks_per_second)
		offset -= velocity * delta
		if velocity.length() < 100: # Threshold to stop
			velocity = Vector2(0, 0)

var prev_event_time := 0
func handle_drag(event: InputEventScreenDrag):
	if is_locked(): return
	points[event.index][1] = event.position
	if (points.size() == 1):
		var displacement: Vector2 = (event.position - points[event.index][0]) / zoom.x
		if displacement.length() < 15 and !dragging:
			return
		
		dragging = true
		#elif displacement.length() < 60: 
			#offset = lerp(offset, intitialCameraPos - displacement, 0.5)
		#else:
		offset = intitialCameraPos - displacement
		
		
		#velocity = event.relative / (Time.get_ticks_usec() - prev_event_time) * 100_000
		var current_time = Time.get_ticks_usec()
		if prev_event_time != 0:
			var time_diff = (current_time - prev_event_time) / 1_000_000.0 # convert usec to sec
			velocity = event.relative / time_diff
			if (velocity.length() > MAX_CAM_SPEED):
				velocity = velocity.normalized() * MAX_CAM_SPEED
		prev_event_time = Time.get_ticks_usec()
	elif (points.size() == 2):
		var start_d = (points.values()[0][0] as Vector2).distance_to(points.values()[1][0])
		var new_d = (points.values()[0][1] as Vector2).distance_to(points.values()[1][1])
		var factor = new_d / start_d
		zoom.x = initialZoom * factor
		zoom.y = initialZoom * factor
		
		var displacement = points.values()[0][0] + points.values()[1][0] - (points.values()[0][1] + points.values()[1][1])
		if displacement.length() < 30:
			return
		offset = intitialCameraPos + displacement / (initialZoom * factor * 2)
