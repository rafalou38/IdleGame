class_name InKnob
extends AspectRatioContainer

# == GLOBAL STATE ==
static var hoveringIn : InKnob = null
static var in_knobs : Array[InKnob] = []

# == NODE REFERENCES ==
@onready var hitbox : CollisionShape2D = $Hitbox
@onready var overlapping_node = get_node("../" + name.replace("in-knob", "out-knob")) as OutKnob

# == ACTUAL STATE ==
var connected := false
@export var enabled := true


func is_target_valid() -> bool:
	return enabled and OutKnob.dragging_out and OutKnob.dragging_out.node_type == "basic" and OutKnob.dragging_out != self.owner and not overlapping_node.connected

func _ready():
	in_knobs.append(self)

func _exit_tree():
	in_knobs.erase(self)

func _process(_delta):
	visible = enabled
	if !enabled: return

	modulate.r = 1.0
	if connected: 
		if OS.is_debug_build():
			modulate.r = 0.5
		return

	if (is_target_valid() or connected) :
		visible = true
	else:
		visible = false
	

func _input(event):
	if connected or !enabled: return
	if overlapping_node.connected:
		return

	

	if event is InputEventScreenDrag:
		var world_pos = Util.screen_to_world(get_viewport(), event.position)
		var innit = hitbox.global_position.distance_to(world_pos) < hitbox.shape.radius
		if(innit and !connected and is_target_valid()):
			hoveringIn = self
		elif hoveringIn == self:
			hoveringIn = null