extends HBoxContainer
class_name UpgradeItem

# InBound
var node : GameNode
var upgrade_type: Upgrades.UpgradeType = Upgrades.UpgradeType.SPEED

# Private
var price: int = 0
var level := 0
var unlocked_level := 0
var id := ""


@onready var button: Button = $Button


func _ready():
	_sync()

func _sync():
	id = Upgrades.upgrade_id(node.type, upgrade_type)

	# Current level
	if !node.data.upgrades.has(upgrade_type):
		node.data.upgrades[upgrade_type] = 0
		level = 0
	else:
		level = node.data.upgrades[upgrade_type]
	
	# UnLockable level
	if Economy.research.has(id):
		if Economy.research[id].state == ResearchTreeItem.State.BOUGHT:
			unlocked_level = Economy.research[id].level
		else:
			unlocked_level = Economy.research[id].level - 1
	
	price = Prices.upgrade_price(upgrade_type, node.type, level+1) / 10

	$Title/Name.text = L.upgrade_name(upgrade_type) 
	$Logo/Icon.texture = Upgrades.upgrade_icons(upgrade_type)

	$Button/VB/HB/Price.text = str(price)
	$Title/HB/Level.text = "Level " + str(level)

	if upgrade_type == Upgrades.UpgradeType.SPEED && node.type == Nodes.NodeType.MINE:
		$Title/HB/Value.text = str(round(Values.mine_speed_duration(level)* 100)/100) + "s"
	elif node.type == Nodes.NodeType.PROCESSOR && upgrade_type == Upgrades.UpgradeType.SPEED:
		$Title/HB/Value.text = str(round(Values.process_speed_duration(level)* 100)/100) + "s"
	elif node.type == Nodes.NodeType.PROCESSOR && upgrade_type == Upgrades.UpgradeType.VALUE:
		$Title/HB/Value.text = "+" + str(round(Values.process_value_increase(level)* 100)/100)


func _process(_delta: float) -> void:
	if level < unlocked_level:
		button.visible = true
	else:
		button.visible = false
		
	if Economy.money < price:
		button.disabled = true
	else:
		button.disabled = false

func _on_button_pressed() -> void:
	if Economy.money >= price:
		Economy.money -= price
		node.data.upgrades[upgrade_type] += 1
		_sync()
