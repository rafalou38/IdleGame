class_name Economy
extends Node2D

static var money := 20.0


static var research := {
    NodeHandler.NodeType.SHOP: {"unlocked": true, "upgrade": 0, "max_buy": 0},
    NodeHandler.NodeType.MINE: {"unlocked": true, "upgrade": 0, "max_buy": 0},
    NodeHandler.NodeType.PROCESSOR: {"unlocked": true, "upgrade": 0, "max_buy": 0},
    NodeHandler.NodeType.REFINERY: {"unlocked": true, "upgrade": 0, "max_buy": 0},
    NodeHandler.NodeType.TETHER: {"unlocked": false, "upgrade": 0, "max_buy": 0},
    NodeHandler.NodeType.DUPLICATOR: {"unlocked": false, "upgrade": 0, "max_buy": 0},
}