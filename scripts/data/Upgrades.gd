extends Node
class_name Upgrades

enum UpgradeType {
    SPEED,
    VALUE,
    RP_MARKET,
    UNLOCK,
}

static var icons: Dictionary[UpgradeType, Resource] = {
    UpgradeType.SPEED : preload("res://sprites/icons/speed.svg"),
    UpgradeType.VALUE : preload("res://sprites/icons/flare.svg"),
    UpgradeType.RP_MARKET : preload("res://sprites/icons/bank.svg"),
}