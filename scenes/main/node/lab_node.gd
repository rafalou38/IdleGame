extends Node2D

@export var process_duration := 1.5
@onready var node : GameNode = $BaseNode


var process_delay := 0.0
func _process(delta):
	if node.input_queue.size() > 0:
		process_delay += delta * NodeHandler.speed_up_factor

		if process_delay >= process_duration:
			var unit = node.input_queue.pop_front()
			unit.type = Unit.UnitType.RESEARCH_POINT
			node.push_unit(unit)

			process_delay = 0
	
	$BaseNode.progress = process_delay / process_duration
