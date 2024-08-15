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


static var _prev_money := 0
static var _prev_money_time := 0
static var _prev_dm := 0
static func var_money() -> float:
    var now = Time.get_unix_time_from_system()
    if now - _prev_money_time >= 20:
        _prev_dm = (money - _prev_money) / (now - _prev_money_time)
        _prev_money = money
        _prev_money_time = now

    return max(0, (money - _prev_money) / (now - _prev_money_time))
