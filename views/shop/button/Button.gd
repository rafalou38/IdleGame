extends Button

@onready var ripple_control = $Control
@onready var animation_player = $AnimationPlayer

# Function to start the ripple effect
func _on_Button_pressed():
	# var ripple = ripple_control.get_child(0)
	# ripple.rect_scale = Vector2(1.0, 1.0)
	# ripple.modulate.a = 1.0
	print("Ripple")
	ripple_control.visible = true
	# Util.screen_to_world(get_viewport(), position)
	ripple_control.position = get_local_mouse_position()

	animation_player.play("Ripple")

func _end():
	ripple_control.visible = false

# Make sure to connect the Button's pressed signal to the _on_Button_pressed function.
func _ready():
	connect("pressed", self._on_Button_pressed)
	animation_player.connect("animation_finished", self._end)

func _process(_delta):
	if disabled:
		modulate.a = 0.5
	else:
		modulate.a = 1.0