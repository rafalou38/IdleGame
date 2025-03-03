extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pass # Replace with function body.
	$AnimationPlayer.play("start_tutorial")



var writing = false
var finished = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Control/PanelContainer2/PanelContainer/HBoxContainer/Label.writing != writing:
		writing = $Control/PanelContainer2/PanelContainer/HBoxContainer/Label.writing
		if writing:
			# $Control/PanelContainer2/PanelContainer/HBoxContainer/Panel/AnimationPlayer.repe
			var animation = $Control/PanelContainer2/PanelContainer/HBoxContainer/Panel/AnimationPlayer.get_animation("spin")
			$Control/PanelContainer2/PanelContainer/HBoxContainer/Panel/AnimationPlayer.speed_scale = 0.95
			animation.loop_mode = Animation.LOOP_LINEAR
			$Control/PanelContainer2/PanelContainer/HBoxContainer/Panel/AnimationPlayer.play("spin")
		else:
			var animation = $Control/PanelContainer2/PanelContainer/HBoxContainer/Panel/AnimationPlayer.get_animation("spin")
			$Control/PanelContainer2/PanelContainer/HBoxContainer/Panel/AnimationPlayer.speed_scale = 2.0
			animation.loop_mode = Animation.LOOP_NONE

	if $Control/PanelContainer2/PanelContainer/HBoxContainer/Label.finished and not finished:
		skip()
	

	visible = not Economy.tutorial_finished

	

func skip():
	$AnimationPlayer.play("close_tutorial")
	finished = true

	Economy.tutorial_finished = true
	$Control/PanelContainer2/PanelContainer/HBoxContainer/Label.end()