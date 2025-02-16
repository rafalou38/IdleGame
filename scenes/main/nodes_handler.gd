class_name NodeHandler
extends Node2D

static var node_ref_by_type: Dictionary = {
	NodeData.NodeType.SHOP: preload("res://scenes/main/node/shop_node.tscn"),
	NodeData.NodeType.MINE: preload("res://scenes/main/node/mine_node.tscn"),
	NodeData.NodeType.PROCESSOR: preload("res://scenes/main/node/processor_node.tscn"),
	NodeData.NodeType.REFINERY: null,
	NodeData.NodeType.TETHER: null,
	NodeData.NodeType.DUPLICATOR: null
}

@export var nodes: Array[GameNode] = []
@export var insert_queue := []

static var speed_up_factor := 1.0

func _ready():
	pass

func load_nodes():
	for node in Economy.owned:
		if (!node.placed): continue

		add_node(node, node.position)
	
	for node in nodes:
		if !node.data.stale_outbound_connections: continue
		
		for conn in node.data.stale_outbound_connections_list:
			var from_knob = node.find_child(conn["fromKnob"])

			var target_node : GameNode
			for node_b in nodes:
				if (node_b.data.id == conn["to"]):
					target_node = node_b
					break

			var to_knob = target_node.find_child(conn["toKnob"])

			node.connect_to(from_knob, to_knob)


func _process(delta):
	speed_up_factor = min((speed_up_factor - 1) * 0.95 + 1, 2.5)

func drag_node(nodeInfo: NodeData, touch_id: int, point: Vector2):
	var node = add_node(nodeInfo, point)

	var displacement = node.find_child("rb")
	displacement.set_target_from_drag(point)
	displacement.dragging = true
	displacement.drag_index = touch_id


func add_node(nodeInfo: NodeData, pos: Vector2):
	var node_ref = NodeHandler.node_ref_by_type[nodeInfo.type]
	var node = node_ref.instantiate()
	var baseNode: GameNode = node.find_child("BaseNode")
	if (baseNode == null):
		push_error("Base node not found")

	baseNode.data = nodeInfo
	nodes.append(baseNode)

	node.find_child("rb").position = pos

	add_child(node)

	return node
