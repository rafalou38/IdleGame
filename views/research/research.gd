@tool
extends Control

@export var open := false
@export var camera: CameraMovement

func _ready():
	var anim = $AnimationPlayer.get_animation("slide_in")
	var trackID = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_out = $AnimationPlayer.get_animation("slide_out")
	var trackID_out = anim_out.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_RESET = $AnimationPlayer.get_animation("RESET")
	var trackID_RESET = anim_RESET.find_track("PanelContainer:position", Animation.TYPE_VALUE)
	

	if trackID != -1 and trackID_out != -1:
		# $Container.size.x = get_viewport_rect().size.x
		anim.track_set_key_value(trackID, 0, Vector2(-get_viewport_rect().size.x, 0))
		anim_out.track_set_key_value(trackID_out, 1, Vector2(-get_viewport_rect().size.x, 0))
		anim_RESET.track_set_key_value(trackID_RESET, 0, Vector2(-get_viewport_rect().size.x, 0))
	else:
		print("track not found")

	$AnimationPlayer.play("RESET")
	# $AnimationPlayer.connect("animation_finished", _anim_finished)

func _process(delta):
	size = $"..".size
	$PanelContainer.size = size
	# pass

func show_research():
	open = true
	$AnimationPlayer.play("slide_in")
	camera.load_state("research")

func hide_research():
	camera.load_state("home")
	open = false
	$AnimationPlayer.play("slide_out")


# func _anim_finished(anim_name):
	# if anim_name == "slide_in":
	# 	owner.find_child("ResearchTree").visible = true
	# 	owner.find_child("Home").visible = false
	# elif anim_name == "slide_out":
	# 	owner.find_child("ResearchTree").visible = false
	# 	owner.find_child("Home").visible = true
