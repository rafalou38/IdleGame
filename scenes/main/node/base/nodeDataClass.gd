extends Resource
class_name NodeData


var id: int
var type: NodeType
var placed: bool
var position: Vector2
var outbound_connections: Array[GameNode.Connection]

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

enum NodeType {
	SHOP,
	MINE,
	PROCESSOR,
	REFINERY,
	TETHER,
	DUPLICATOR
}
