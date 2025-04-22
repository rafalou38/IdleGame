class_name Resources
extends Node2D

static var researchIcons: Dictionary[Upgrades.UpgradeType, Resource] = {
    Upgrades.UpgradeType.SPEED : preload("res://sprites/icons/speed.svg"),
    Upgrades.UpgradeType.VALUE : preload("res://sprites/icons/flare.svg"),
    Upgrades.UpgradeType.RP_MARKET : preload("res://sprites/icons/bank.svg"),
}