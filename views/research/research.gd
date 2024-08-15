extends Control

@export var open := false

func _ready():
	var anim = $AnimationPlayer.get_animation("slide_in")
	var trackID = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_out = $AnimationPlayer.get_animation("slide_out")
	var trackID_out = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_RESET = $AnimationPlayer.get_animation("RESET")
	var trackID_RESET = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	if trackID != -1 and trackID_out != -1:
		anim.track_set_key_value(trackID, 0, Vector2(get_viewport_rect().size.x, 0))
		anim_out.track_set_key_value(trackID_out, 1, Vector2(get_viewport_rect().size.x, 0))
		anim_RESET.track_set_key_value(trackID_RESET, 0, Vector2(get_viewport_rect().size.x, 0))
	else:
		print("track not found")

	$AnimationPlayer.play("RESET")
	# $AnimationPlayer.connect("animation_finished", _anim_finished)

func show_research():
	open = true
	$AnimationPlayer.play("slide_in")

func hide_research():
	open = false
	$AnimationPlayer.play("slide_out")