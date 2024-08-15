@tool
class_name BottomBarButton
extends Button

@export var ref_icon : Texture2D
@export var ref_name : String

static var focused := "HOME"
var self_focused := true

func _ready():
	$VBoxContainer/CenterContainer/TextureRect.texture = ref_icon
	$VBoxContainer/Label.text = ref_name
	$VBoxContainer.size = size


func _process(_delta):
	$VBoxContainer.size = size

	if self_focused and focused.to_lower() != ref_name.to_lower():
		self_focused = false
		$AnimationPlayer.play("FocusOut")

	if not self_focused and focused.to_lower() == ref_name.to_lower():
		self_focused = true
		$AnimationPlayer.play("Focus")
