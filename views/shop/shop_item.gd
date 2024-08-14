@tool
extends HBoxContainer

@export var type: NodeHandler.NodeType = NodeHandler.NodeType.SHOP

@export var item_name: String = ""
@export var item_description: String = ""
@export var icon: Texture2D = null
@export var icon_bg_color := Color(0, 0, 0, 1)

@export var can_buy: bool = true
@export var unlocked: bool = false
@export var bought: int = 0
@export var price: float = 0

signal buy

func apply_props():
	# This seems to be what breaks it
	unlocked = Economy.research[type]["unlocked"] 

	price = Prices.node_buy(type, bought)


	visible = unlocked
	if not unlocked: return

	$VBoxContainer/Label.text = item_name
	$VBoxContainer/Label2.text = item_description
	$CenterContainer2/Button.disabled = not can_buy

	$VBoxContainer/HBoxContainer/Label.text = str(bought)
	$CenterContainer2/Button.text = Util.number_to_human(price)

	if icon: $CenterContainer/Icon.texture = icon
	if icon_bg_color: $CenterContainer/IconBackground.self_modulate = icon_bg_color

func _ready():
	apply_props()

func _process(_delta):
	apply_props()

func _buy_button_pressed():
	if can_buy:
		bought += 1
		owner.buy(type)

		apply_props()