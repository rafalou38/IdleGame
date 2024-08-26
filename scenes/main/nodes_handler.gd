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

static var node_ref_by_type : Dictionary = {
	NodeType.SHOP: preload("res://scenes/main/node/shop_node.tscn"),
	NodeType.MINE: preload("res://scenes/main/node/mine_node.tscn"),
	NodeType.PROCESSOR: preload("res://scenes/main/node/processor_node.tscn"),
	NodeType.REFINERY: null,
	NodeType.TETHER: null,
	NodeType.DUPLICATOR: null
}

@export var nodes : Array = []
@export var insert_delayed := false
@export var insert_queue := []

static var speed_up_factor := 1.0

func _ready():
	add_node(NodeType.SHOP)
	add_node(NodeType.MINE)
	# add_node(NodeType.PROCESSOR)
	# add_node(NodeType.PROCESSOR)
	# add_node(NodeType.PROCESSOR)
	# add_node(NodeType.PROCESSOR)
	pass


var time_since_last_insert : float = 0.0
func _process(delta):
	speed_up_factor = min((speed_up_factor-1) * 0.8 * (1/(delta * 60)) + 1, 2.5)

	time_since_last_insert += delta
	if !insert_delayed and insert_queue.size() > 0 and time_since_last_insert > 0.5:
		time_since_last_insert = 0
		# for i in range(insert_queue.size()):
		var item = insert_queue.pop_front()
		item.get_children()[0].visible = false
		item.get_children()[0]._ready()
		item.find_child("CollisionShape2D").shape.height = 0
		item.find_child("CollisionShape2D").shape.radius = 0

		add_child(item)
			


func add_node(type: NodeType):
	var node_ref = node_ref_by_type[type]
	var node = node_ref.instantiate()
	nodes.append(node)
	var pos = Vector2(randi_range(-1000, 1000), randi_range(-1000, 1000))
	# var posing = true
	# while posing:
	# 	posing = false
	# 	for other in nodes:
	# 		# Check collision overlap
	# 		if pos.distance_to(other.position) < 200:
	# 			posing = true
	# 			pos = Vector2(randf() * 1000 - 500, randf() * 1000 - 500)
	# 			break

	node.position = pos

	insert_queue.append(node)

	time_since_last_insert = 0