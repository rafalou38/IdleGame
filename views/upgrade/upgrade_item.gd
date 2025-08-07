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
	
	price = Prices.upgrade_price(upgrade_type, node.type, level+1) / 4

	$Title/Name.text = L.upgrade_name(upgrade_type) 
	$Logo/Icon.texture = Upgrades.upgrade_icons(upgrade_type)


	$Title/HB/Value.text = ""
	$Button/VB/HB/Price.text = str(price)

	if upgrade_type != Upgrades.UpgradeType.RP_MARKET:
		$Title/HB/Level.text = "Level " + str(level)
		if upgrade_type == Upgrades.UpgradeType.SPEED && node.type == Nodes.NodeType.MINE:
			$Title/HB/Value.text = str(round(Values.mine_speed_duration(level)* 100)/100) + "s"
		elif node.type == Nodes.NodeType.PROCESSOR && upgrade_type == Upgrades.UpgradeType.SPEED:
			$Title/HB/Value.text = str(round(Values.process_speed_duration(level)* 100)/100) + "s"
		elif node.type == Nodes.NodeType.PROCESSOR && upgrade_type == Upgrades.UpgradeType.VALUE:
			$Title/HB/Value.text = "+" + str(round(Values.process_value_increase(level)* 100)/100)
	elif level == 0:
		$Title/HB/Level.text = "DISABLED"
	elif level == 1:
		$Title/HB/Level.text = "ENABLED"
	



func _process(_delta: float) -> void:		
	print(level," ", unlocked_level)
	if Economy.money < price || level >= unlocked_level:
		button.disabled = true
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		# button.modulate.a = 0.5
	else:
		button.disabled = false
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		# button.modulate.a = 1
	
	if level < unlocked_level:
		$Button/VB/HB.visible = true
		$Button/VB/HB2.visible = true
		$Button/VB/HB2.visible = true
		$Button/VB/HB2/Price.text = "Lvl " + str(level+1)
	else:
		$Button/VB/HB.visible = false
		$Button/VB/HB2.visible = true
		$Button/VB/HB2/Price.text = "LOCKED"

	if upgrade_type == Upgrades.UpgradeType.RP_MARKET:
		$Button/VB/HB.visible = false
		$Button/VB/HB2.visible = true
		if level == 0:
			$Button/VB/HB.visible = true
			$Button/VB/HB2.visible = true
			$Button/VB/HB2.visible = true
			$Button/VB/HB2/Price.text = "enable"
		else:
			$Button/VB/HB2/Price.text = "Bought"

func _on_button_pressed() -> void:
	if Economy.money >= price && level < unlocked_level:
		Economy.money -= price
		node.data.upgrades[upgrade_type] += 1
		_sync()
