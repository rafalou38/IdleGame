extends HBoxContainer
class_name UpgradeItem

@export var node_type: Nodes.NodeType = Nodes.NodeType.SHOP
@export var upgrade_type: Upgrades.UpgradeType = Upgrades.UpgradeType.SPEED

@export var current_level: int = 1
var id: String = ""
var price: int = 0

func _sync():
	# match upgrade_type:
	# 	Upgrades.UpgradeType.SPEED:
	# 		$Title/Name.text = "Speed Upgrade"
	# 		$Title/HB/Value.text = "1.5s"
	# 	Upgrades.UpgradeType.VALUE:
	# 		$Title/Name.text = "Value Upgrade"
	# 		$Title/HB/Value.text = "1.1x"
	# 	Upgrades.UpgradeType.RP_MARKET:
	# 		$Title/Name.text = "RP market"
	# 		$Title/HB/Value.text = ""

	# 	_:
	# 		$Title/Name.text = "UB"
	$Title/Name.text = L.upgrade_name(upgrade_type)
	$Title/HB/Value.text = L.upgrade_desc(upgrade_type)
	$Title/HB/Level.text = "Level " + str(current_level)
	$Logo/Icon.texture = Upgrades.upgrade_icons(upgrade_type)
	

func _process(_delta: float) -> void:
	_sync()
