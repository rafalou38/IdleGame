@tool
extends HBoxContainer
class_name UpgradeItem

enum UpgradeType {
    SPEED,
    VALUE,
    RP_MARKET
}

var icons: Dictionary[UpgradeType, Resource] = {
    UpgradeType.SPEED : preload("res://sprites/icons/speed.svg"),
    UpgradeType.VALUE : preload("res://sprites/icons/flare.svg"),
    UpgradeType.RP_MARKET : preload("res://sprites/icons/bank.svg"),
}

@export var node_type: NodeData.NodeType = NodeData.NodeType.SHOP
@export var upgrade_type: UpgradeType = UpgradeType.SPEED

@export var current_level: int = 1
var id: String = ""
var price: int = 0


func _sync():
    match upgrade_type:
        UpgradeType.SPEED:
            $Title/Name.text = "Speed Upgrade"
            $Title/HB/Value.text = "1.5s"
        UpgradeType.VALUE:
            $Title/Name.text = "Value Upgrade"
            $Title/HB/Value.text = "1.1x"
        UpgradeType.RP_MARKET:
            $Title/Name.text = "RP market"
            $Title/HB/Value.text = ""

        _:
            $Title/Name.text = "UB"

    $Title/HB/Level.text = "Level " + str(current_level)
    $Logo/Icon.texture = icons[upgrade_type]
    

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    _sync()
    pass