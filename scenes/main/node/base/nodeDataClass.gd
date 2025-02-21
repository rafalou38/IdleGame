extends Resource
class_name NodeData


var id: int
var type: NodeType

var placed: bool = false
var position: Vector2 = Vector2(0, 0)
var outbound_connections: Array[GameNode.Connection] = []
var stale_outbound_connections_list: Array[Dictionary] = []
var stale_outbound_connections: bool = false

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
		"outbound_connections": outbound_connections_serialized
	}

static func deserialize(d: Dictionary) -> NodeData:
	var node = NodeData.new()
	node.id = d["id"]
	node.type = d["type"]
	node.placed = d["placed"]
	node.position = Vector2(d["position"]["x"], d["position"]["y"])
	node.outbound_connections.clear()

	if (d["outbound_connections"].size() > 0):
		node.stale_outbound_connections = true
		node.stale_outbound_connections_list.assign(d["outbound_connections"])

	return node

enum NodeType {
	SHOP,
	MINE,
	PROCESSOR,
	REFINERY,
	TETHER,
	DUPLICATOR,
	RESEARCH_CENTER,
	LAB
}
