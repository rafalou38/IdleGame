extends Node
class_name Upgrades

enum UpgradeType {
    SPEED,
    VALUE,
    RP_MARKET,
    UNLOCK,
}


static func upgrade_id(node_type: Nodes.NodeType, upgrade_type: UpgradeType, level: int) -> String:
    return str(upgrade_type) + "_" + str(node_type) + "_" + str(level)