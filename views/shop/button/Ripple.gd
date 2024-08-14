extends Control

@onready var animation_player = $AnimationPlayer
@onready var btn = $".."

# Function to start the ripple effect
func _on_Button_pressed():
	self.visible = true
	self.global_position = self.get_global_mouse_position()

	animation_player.play("RESET")
	animation_player.play("Ripple")

func _end(_anim_name: StringName):
	self.visible = false

func _ready():
	btn.connect("button_down", self._on_Button_pressed)
	animation_player.connect("animation_finished", self._end)
	animation_player.play("RESET")
