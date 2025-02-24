@tool
class_name BottomBarButton
extends Button

@export var ref_icon: Texture2D
@export var ref_name: String
@export var ping := 0
var prev_ping := 0

static var focused := "HOME"
var self_focused := true

func _ready():
	$VBoxContainer/CenterContainer/TextureRect.texture = ref_icon
	$VBoxContainer/Label.label_settings = $VBoxContainer/Label.label_settings.duplicate()
	$VBoxContainer/CenterContainer/PanelContainer/Label.label_settings = $VBoxContainer/CenterContainer/PanelContainer/Label.label_settings.duplicate()
	
	$VBoxContainer/Label.text = ref_name
	$VBoxContainer.size = size
	$AnimationPlayer.play("RESET")



func _process(_delta):
	if (ping != prev_ping):
		if (ping > 0):
			$AnimationPlayer2.play("pop-in")
		else:
			$AnimationPlayer2.play("pop-out")
		prev_ping = ping

	$VBoxContainer/CenterContainer/PanelContainer/Label.text = str(ping)
	
	$VBoxContainer.size = size

	if self_focused and focused.to_lower() != ref_name.to_lower():
		self_focused = false
		$AnimationPlayer.play("FocusOut")

	if not self_focused and focused.to_lower() == ref_name.to_lower():
		self_focused = true
		$AnimationPlayer.play("Focus")
