@tool
extends Control

@export var open := false
@export var camera: CameraMovement

func _ready():
	sync_dims()

	$AnimationPlayer.play("RESET")
	# $AnimationPlayer.connect("animation_finished", _anim_finished)

func _process(_delta):
	sync_dims()

func sync_dims():
	size = $"..".size
	$PanelContainer.size = size

	var anim_slide_in = $AnimationPlayer.get_animation("slide_in")
	var trackID_slide_in = anim_slide_in.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_slide_out = $AnimationPlayer.get_animation("slide_out")
	var trackID_slide_out = anim_slide_out.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_RESET = $AnimationPlayer.get_animation("RESET")
	var trackID_RESET = anim_RESET.find_track("PanelContainer:position", Animation.TYPE_VALUE)
	

	if trackID_slide_in != -1 and trackID_slide_out != -1:
		# $Container.size.x = get_viewport_rect().size.x
		anim_slide_in.track_set_key_value(trackID_slide_in, 0, Vector2(-size.x, 0))
		anim_slide_out.track_set_key_value(trackID_slide_out, 1, Vector2(-size.x, 0))
		anim_RESET.track_set_key_value(trackID_RESET, 0, Vector2(-size.x, 0))
	else:
		print("track not found")


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
