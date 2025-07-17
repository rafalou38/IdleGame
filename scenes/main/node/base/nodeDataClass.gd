extends Resource
class_name NodeData


var id: int
var type: Nodes.NodeType

var placed: bool = false
var position: Vector2 = Vector2(0, 0)
var outbound_connections: Array[GameNode.Connection] = []
var stale_outbound_connections_list: Array[Dictionary] = []
var stale_outbound_connections: bool = false
var upgrades : Dictionary[Upgrades.UpgradeType, int]

func serialize() -> Dictionary:
	var outbound_connections_serialized = outbound_connections.map(func(o): return {
		"from": o.fromNode.data.id,
		"fromKnob": o.fromKnob.name,
		"to": o.toNode.data.id,
		"toKnob": o.toKnob.name
	})

	return {
		"id": id,
		"type": type,
		"placed": placed,
		"position": {
			"x": position.x,
			"y": position.y
		},
		"outbound_connections": outbound_connections_serialized,
		"upgrades": upgrades
	}

static func deserialize(d: Dictionary) -> NodeData:
	var node = NodeData.new()
	node.id = d["id"]
	node.type = d["type"]
	node.placed = d["placed"]
	node.position = Vector2(d["position"]["x"], d["position"]["y"])
	node.outbound_connections.clear()
	for up_id in d["upgrades"]:
		node.upgrades[up_id] = int(d["upgrades"][up_id])

	if (d["outbound_connections"].size() > 0):
		node.stale_outbound_connections = true
		node.stale_outbound_connections_list.assign(d["outbound_connections"])

	print(node)

	return node
