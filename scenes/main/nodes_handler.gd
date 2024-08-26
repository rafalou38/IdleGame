class_name NodeHandler
extends Node2D

enum NodeType {
	SHOP,
	MINE,
	PROCESSOR,
	REFINERY,
	TETHER,
	DUPLICATOR
}

static var node_ref_by_type: Dictionary = {
	NodeType.SHOP: preload("res://scenes/main/node/shop_node.tscn"),
	NodeType.MINE: preload("res://scenes/main/node/mine_node.tscn"),
	NodeType.PROCESSOR: preload("res://scenes/main/node/processor_node.tscn"),
	NodeType.REFINERY: null,
	NodeType.TETHER: null,
	NodeType.DUPLICATOR: null
}

@export var nodes: Array = []
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

func drag_node(nodeInfo: Dictionary, touch_id: int, point: Vector2):
	var node = add_node(nodeInfo, point)

	var displacement = node.find_child("rb")
	displacement.set_target_from_drag(point)
	displacement.dragging = true
	displacement.drag_index = touch_id


func add_node(nodeInfo: Dictionary, pos: Vector2):
	var node_ref = node_ref_by_type[nodeInfo.type]
	var node = node_ref.instantiate()
	nodes.append(node)

	node.position = pos

	add_child(node)

	return node
