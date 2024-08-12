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

@export var node_ref_by_type : Dictionary = {
	NodeType.SHOP: preload("res://scenes/main/node/shop_node.tscn"),
	NodeType.MINE: preload("res://scenes/main/node/mine_node.tscn"),
	NodeType.PROCESSOR: preload("res://scenes/main/node/processor_node.tscn"),
	# NodeType.REFINERY: null,
	# NodeType.TETHER: null,
	# NodeType.DUPLICATOR: null
}

@export var nodes : Array[GameNode] = []
@export var insert_delayed := false
@export var insert_queue := []


func _ready():
	add_node(NodeType.SHOP)
	add_node(NodeType.MINE)
	add_node(NodeType.PROCESSOR)
	add_node(NodeType.PROCESSOR)
	add_node(NodeType.PROCESSOR)
	add_node(NodeType.PROCESSOR)


var time_since_last_insert : float = 0.0
func _process(delta):
	time_since_last_insert += delta
	if !insert_delayed and insert_queue.size() > 0:
		for i in range(insert_queue.size()):
			var item = insert_queue.pop_front()
			item.get_children()[0].visible = false
			item.get_children()[0].spawn_timeout = 0.5 * (i)

			add_child(item)
			


func add_node(type: NodeType):
	var node_ref = node_ref_by_type[type]
	var node = node_ref.instantiate()
	nodes.append(node)
	node.position = Vector2(randf() * 200 - 100, randf() * 200 - 100)
	insert_queue.append(node)

	time_since_last_insert = 0