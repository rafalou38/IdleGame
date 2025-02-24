extends Node2D

@onready var node : GameNode = $BaseNode

var bank := 0.0
var bank_rp := 0.0


func _process(_delta):
	if node.input_queue.size() > 0:
		var unit = node.input_queue.pop_front()

		if Economy.active_research != "":
			var id = Economy.active_research
			var research = Economy.research[id]

			if(unit.type == Unit.UnitType.UNIT):
				research["spent"] += unit.value
				# bank += unit.value
			elif (unit.type == Unit.UnitType.RESEARCH_POINT):
				research["spent_rp"] += unit.value
				# bank_rp += unit.value

			# if research["price"] > research["spent"]:
			# 	var spent = max(research["price"] - research["spent"], bank) 
			# 	bank -= spent
			# 	research["spent"] += bank

			# if research["price_rp"] > research["spent_rp"]:
			# 	var spent = max(research["price_rp"] - research["spent_rp"], bank) 
			# 	bank_rp -= spent
			# 	research["spent_rp"] += bank_rp
			
		unit.destroy()
		unit.queue_free()
	
