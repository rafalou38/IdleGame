extends Node2D

@export var increment := 0.1
@onready var node : GameNode = $BaseNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# print(node.input_queue)
	if node.input_queue.size() > 0:
		var unit = node.input_queue.pop_front()
		unit.value += increment

		node.push_unit(unit)
