class_name Economy
extends Node2D

static var money := 20.0


static var research := {
    NodeHandler.NodeType.SHOP: {"unlocked": true},
    NodeHandler.NodeType.MINE: {"unlocked": true},
    NodeHandler.NodeType.PROCESSOR: {"unlocked": true},
    NodeHandler.NodeType.REFINERY: {"unlocked": true},
    NodeHandler.NodeType.TETHER: {"unlocked": false},
    NodeHandler.NodeType.DUPLICATOR: {"unlocked": false},
}

static var owned := [
    # {
    #     "id": int,
    #     "type": NodeHandler.NodeType,
    #     "placed": bool
    #     "outbound": [
    #         {
    #             "target_id": int,
    #             "origin_knob_name": String
    #             "target_knob_name": String
    #         }
    #     ]
    #     "position": Vector2
    # }
]

static var _prev_money := 0.0
static var _prev_money_time := 0.0
static var _dvm := 0.0
static func var_money() -> float:
    var now = Time.get_unix_time_from_system()

    if _prev_money > money:
        _prev_money = money
        _prev_money_time = now
    elif _prev_money < money:
        var nv := lerpf(_dvm, (money - _prev_money) / (now - _prev_money_time), 0.8)
        # if _dvm > 1 and nv > _dvm * 1.8: _dvm = _dvm * 1.8
        # else: _dvm = nv

        _dvm = nv

        _prev_money_time = now
        _prev_money = money

    return _dvm
