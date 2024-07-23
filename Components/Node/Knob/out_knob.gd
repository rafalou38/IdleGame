extends AspectRatioContainer


var touch_pos := Vector2.ZERO
var original_pos := Vector2.ZERO
var connection_initiated := false
var touch_index := 0
var retract := false

@onready var line : Line2D = $Line
@onready var hitbox : CollisionShape2D = $Hitbox

func initiateConnection(origin_pos_new: Vector2):
	# This must be ran after touch_index received
	original_pos = origin_pos_new
	retract = false
	connection_initiated = true
	CameraMovement.control_locks.append("knob-manager/" + str(touch_index))

func finishConnection():
	connection_initiated = false

	retract = true
	CameraMovement.control_locks.erase("knob-manager/" + str(touch_index))

func isTouchUsed(index: int):
	return CameraMovement.control_locks.has("NodeDisplacement/" + str(index))

func _input(event):
	# print(CameraMovement.control_locks)
	var world_pos = Util.screen_to_world(get_viewport(), event.position)
	if event is InputEventScreenTouch:
		if event.pressed and !connection_initiated and !isTouchUsed(event.index):
			if(hitbox.global_position.distance_to(world_pos) < hitbox.shape.radius):
				touch_index = event.index
				initiateConnection(hitbox.global_position)
				
		if !event.pressed and event.index == touch_index:
			finishConnection()


	if event is InputEventScreenDrag and connection_initiated and event.index == touch_index:
		if isTouchUsed(event.index):
			finishConnection()
			return

		touch_pos = world_pos
		line.points[0] =  line.to_local(original_pos)
		line.points[1] =  line.to_local(touch_pos)
		

func _process(delta):
	if retract:
		line.points[1] = line.points[1].lerp(line.points[0], 0.4 * delta * 60)
