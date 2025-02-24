extends Node2D

@onready var node : GameNode = $BaseNode

func _process(_delta):
	if node.input_queue.size() > 0:
		var unit = node.input_queue.pop_front()

		if Economy.active_research != "":
			var id = Economy.active_research
			var research = Economy.research[id]

			if(unit.type == Unit.UnitType.UNIT):
				research["spent"] += 1
			elif (unit.type == Unit.UnitType.RESEARCH_POINT):
				research["spent_rp"] += 1
			
		unit.destroy()
		unit.queue_free()
