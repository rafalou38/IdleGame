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
	# add_node(NodeType.SHOP)
	# add_node(NodeType.MINE)
	# add_node(NodeType.PROCESSOR)
	# add_node(NodeType.PROCESSOR)
	# add_node(NodeType.PROCESSOR)
	# add_node(NodeType.PROCESSOR)
	pass


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
	var baseNode : GameNode = node.find_child("BaseNode")
	if(baseNode == null):
		push_error("Base node not found")

	baseNode.data = nodeInfo
	nodes.append(baseNode)

	node.position = pos

	add_child(node)

	return node
