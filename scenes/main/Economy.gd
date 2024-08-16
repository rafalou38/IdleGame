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


static var _prev_money := 0.0
static var _prev_money_time := 0.0
static var _dvm := 0.0
static func var_money() -> float:
    var now = Time.get_unix_time_from_system()

    if _prev_money > money:
        _prev_money = money
        _prev_money_time = now
    if _prev_money < money:
        _dvm = min(lerpf(_dvm, (money - _prev_money) / (now - _prev_money_time), 0.8), _dvm * 1.8)

        _prev_money_time = now
        _prev_money = money

    return _dvm
