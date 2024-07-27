@tool
extends HBoxContainer

@export var item_name: String = ""
@export var item_description: String = ""
@export var icon: Texture2D = null
@export var icon_bg_color := Color(0, 0, 0, 1)

@export var can_buy: bool = false
@export var bought: int = 0

func apply_props():
	$VBoxContainer/Label.text = item_name
	$VBoxContainer/Label2.text = item_description
	$CenterContainer2/Button.disabled = not can_buy

	$VBoxContainer/HBoxContainer/Label.text = str(bought)

	if icon: $CenterContainer/Icon.texture = icon
	if icon_bg_color: $CenterContainer/IconBackground.self_modulate = icon_bg_color
# Other properties and methods
func _ready():
	apply_props()

func _process(_delta):
	if Engine.is_editor_hint():
		apply_props()