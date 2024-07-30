extends Control

var open := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_shop():
	open = true
	$AnimationPlayer.play("slide_in")


func _handle_button_close():
	open = false
	$AnimationPlayer.play_backwards("slide_in")

