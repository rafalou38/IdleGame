extends Node2D

@onready var node : GameNode = $BaseNode

var speed_level = 0
var value_level = 0 
var process_delay := 0.0
func _process(delta):
	if node.input_queue.size() > 0:
		process_delay += delta * NodeHandler.speed_up_factor  * (Boost.get_boost(3))
		
		if $BaseNode.data.upgrades.has(Upgrades.UpgradeType.SPEED):
			speed_level = $BaseNode.data.upgrades[Upgrades.UpgradeType.SPEED]
		if $BaseNode.data.upgrades.has(Upgrades.UpgradeType.VALUE):
			value_level = $BaseNode.data.upgrades[Upgrades.UpgradeType.VALUE]

		if process_delay >= Values.process_speed_duration(speed_level):
			var unit = node.input_queue.pop_front()
			unit.value += Values.process_value_increase(value_level)
			node.push_unit(unit)
			process_delay = 0
	
	$BaseNode.progress = process_delay / Values.process_speed_duration(speed_level)
