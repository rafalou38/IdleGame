extends Node2D

@export var increment := 0.1
@onready var node : GameNode = $BaseNode

func _process(_delta):
	if node.input_queue.size() > 0:
		var unit = node.input_queue.pop_front()
		unit.value += increment
		node.push_unit(unit)
