class_name OutKnob

extends AspectRatioContainer


# == GLOBAL STATE ==
static var dragging_out : GameNode = null
static var out_knobs : Array[OutKnob] = []

# == CONNECT PHASE ==
var touch_pos := Vector2.ZERO
var original_pos := Vector2.ZERO
var connection_initiated := false
var touch_index := -1
var retract := false

# == ACTUAL STATE ==
var connected := false


# == NODE REFERENCES ==
@onready var line : Line2D = $Line
@onready var hitbox : CollisionShape2D = $Hitbox
@onready var overlapping_node = get_node("../" + name.replace("out-knob", "in-knob")) as InKnob


func _ready():
	out_knobs.append(self)

func _exit_tree():
	out_knobs.erase(self)

func initiateConnection(origin_pos_new: Vector2):
	# Check if overlapping node is connected
	if overlapping_node.connected:
		return

	if connected:
		owner.dispose_connection(self, null)

	connected = false
	original_pos = origin_pos_new
	retract = false
	connection_initiated = true
	CameraMovement.control_locks.append("knob-manager/" + str(touch_index))
	dragging_out = owner

func finishConnection():
	if InKnob.hoveringIn and connection_initiated:
		owner.connect_to(self, InKnob.hoveringIn)
		InKnob.hoveringIn = null
	else:
		retract = true
		CameraMovement.control_locks.erase("knob-manager/" + str(touch_index))
	connection_initiated = false
	dragging_out = null
	touch_pos = Vector2.ZERO

func isTouchUsed(index: int):
	return CameraMovement.control_locks.has("NodeDisplacement/" + str(index))

func _input(event):
	# if connected: return
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

func _process(delta):

	modulate.r = 1.0
	if connected: 
		if OS.is_debug_build():
			modulate.r = 0.5
		return

	if connection_initiated and touch_pos != Vector2.ZERO:
		line.points[0] =  line.to_local(hitbox.global_position)
		line.points[1] =  line.to_local(touch_pos)

		if InKnob.hoveringIn:
			line.points[1] = line.to_local(InKnob.hoveringIn.global_position) + InKnob.hoveringIn.pivot_offset
		
	if dragging_out and !connection_initiated and !connected or overlapping_node.connected:
		visible = false
	else:
		visible = true
	if retract and !connected:
		line.points[1] = line.points[1].lerp(line.points[0], 0.4 * delta * 60)
