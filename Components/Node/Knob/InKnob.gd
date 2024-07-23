class_name InKnob
extends AspectRatioContainer

static var hoveringIn : InKnob
@onready var hitbox : CollisionShape2D = $Hitbox
var  connected := false

func _process(_delta):
	if connected: return
	if OutKnob.dragging_out and OutKnob.dragging_out.node_type == "basic" or connected:
		visible = true
	else:
		visible = false
	

func _input(event):
	if connected: return
	var world_pos = Util.screen_to_world(get_viewport(), event.position)
	var innit = hitbox.global_position.distance_to(world_pos) < hitbox.shape.radius

	if event is InputEventScreenDrag:
		if(innit and !connected):
			hoveringIn = self
		elif hoveringIn == self:
			hoveringIn = null