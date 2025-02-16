class_name Economy
extends Node2D

static var money := 20.0

static var research := {
    NodeData.NodeType.SHOP: {"unlocked": true},
    NodeData.NodeType.MINE: {"unlocked": true},
    NodeData.NodeType.PROCESSOR: {"unlocked": true},
    NodeData.NodeType.REFINERY: {"unlocked": true},
    NodeData.NodeType.TETHER: {"unlocked": false},
    NodeData.NodeType.DUPLICATOR: {"unlocked": false},
}

static var owned: Array[NodeData] = [
    # {
    #     "id": int,
    #     "type": NodeData.NodeType,
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
    # {
    #     "id": 0,
    #     "type": NodeData.NodeType.SHOP,
    #     "placed": false,
    #     "outbound": [],
    #     "position": Vector2(0, 0)
    # }
]

static func _save():
    var serialized_economy = {
        "research": research,
        "owned": owned.map(func(e): return e.serialize()),
        "money": money
    }

    # JSON provides a static method to serialized JSON string.
    var json_string = JSON.stringify(serialized_economy)

    # print(serialized_economy)
    # print(json_string)

    # # Store the save dictionary as a new line in the save file.
    # save_file.store_line(json_string)

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
