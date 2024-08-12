extends Control

@onready var animation_player = $AnimationPlayer
@onready var btn = $".."

# Function to start the ripple effect
func _on_Button_pressed():
	# var ripple = self.get_child(0)
	# ripple.rect_scale = Vector2(1.0, 1.0)
	# ripple.modulate.a = 1.0
	print("Ripple")
	self.visible = true
	# Util.screen_to_world(get_viewport(), position)
	self.global_position = self.get_global_mouse_position()

	animation_player.play("RESET")
	animation_player.play("Ripple")

func _end(_anim_name: StringName):
	self.visible = false

# Make sure to connect the Button's pressed signal to the _on_Button_pressed function.
func _ready():
	btn.connect("button_down", self._on_Button_pressed)
	animation_player.connect("animation_finished", self._end)
	animation_player.play("RESET")

# func _process(_delta):
# 	if btn.disabled:
# 		modulate.a = 0.5
# 	else:
# 		modulate.a = 1.0
