extends Node2D

@onready var node : GameNode = $BaseNode

func _process(_delta):
	if node.input_queue.size() > 0:
		var unit = node.input_queue.pop_front()
		unit.destroy()

		if(unit.type == Unit.UnitType.UNIT):
			Economy.money += unit.value

		unit.queue_free()
