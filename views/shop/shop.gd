extends Control

var hide_timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _handle_button_close():
	hide_timer = get_tree().create_timer(0.4)
	await hide_timer.timeout
	visible = false

