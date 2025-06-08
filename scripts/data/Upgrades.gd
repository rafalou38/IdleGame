extends Node
class_name Upgrades

enum UpgradeType {
    SPEED,
    VALUE,
    RP_MARKET,
    UNLOCK,
}
static var _icons: Dictionary[UpgradeType, Resource]
static func upgrade_icons(t: UpgradeType) -> Resource:
    if !_icons.has(t):
        _icons = {
            Upgrades.UpgradeType.SPEED: preload("res://sprites/icons/speed.svg"),
            Upgrades.UpgradeType.VALUE: preload("res://sprites/icons/flare.svg"),
            Upgrades.UpgradeType.RP_MARKET: preload("res://sprites/icons/bank.svg"),
        }

    return _icons[t]

static func upgrade_id(node_type: Nodes.NodeType, upgrade_type: UpgradeType, level: int) -> String:
    return str(upgrade_type) + "_" + str(node_type) + "_" + str(level)


# TODO: safety
static func upgrade_type_from_id(id: String) -> UpgradeType:
    return int(id.split("_")[0])

static func node_type_from_id(id: String) -> Nodes.NodeType:
    return int(id.split("_")[1])

static func level_from_id(id: String) -> int:
    return int(id.split("_")[2])