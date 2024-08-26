# @tool
extends HBoxContainer

@export var type: NodeHandler.NodeType = NodeHandler.NodeType.SHOP

@export var item_name: String = ""
@export var item_description: String = ""
@export var icon: Texture2D = null
@export var icon_bg_color := Color(0, 0, 0, 1)

@export var can_buy: bool = false
@export var unlocked: bool = false
@export var bought: int = 0
@export var price: float = 0

signal buy

func apply_props():
	unlocked = Economy.research[type]["unlocked"]
	price = Prices.node_buy(type, bought)

	can_buy = price <= Economy.money or (OS.is_debug_build() and Input.is_key_pressed(KEY_SHIFT))

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

var last_node_count = -1
func _process(_delta: float) -> void:
	if last_node_count != Economy.owned.size():
		last_node_count = Economy.owned.size()
		bought = 0
		for node in Economy.owned:
			if node["type"] == type:
				bought += 1

	apply_props()

func _buy_button_pressed():
	apply_props() # To check if can_buy
	
	if can_buy:
		Economy.money -= price
		bought += 1
		owner.buy(type)

		apply_props()