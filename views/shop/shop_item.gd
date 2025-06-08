@tool
extends HBoxContainer

@export var type: Nodes.NodeType = Nodes.NodeType.SHOP

var can_buy: bool = false
var unlocked: bool = false
var bought: int = 0
var price: float = 0

signal buy

func apply_props():
	var id := Upgrades.upgrade_id(type, Upgrades.UpgradeType.UNLOCK)
	# print(id, Economy.research.has(id))
	if Engine.is_editor_hint():
		unlocked = true
	elif (Economy.research.has(id)):
		unlocked = Economy.research[id]["state"] == ResearchTreeItem.State.BOUGHT
	else:
		unlocked = false
		
	price = Prices.node_buy(type, bought)

	can_buy = price <= Economy.money or (OS.is_debug_build() and Input.is_key_pressed(KEY_SHIFT))

	visible = unlocked
	if not unlocked: return

	$VBoxContainer/Label.text = L.node_name(type)
	$VBoxContainer/Label2.text = L.node_desc(type)
	$CenterContainer2/Button.disabled = not can_buy

	$VBoxContainer/HBoxContainer/Label.text = str(bought)
	$CenterContainer2/Button.text = Util.number_to_human(price)

	$CenterContainer/Icon.texture = Nodes.node_icons(type)
	$CenterContainer/IconBackground.self_modulate = Nodes.node_color(type)

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
