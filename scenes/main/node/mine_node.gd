extends Node2D

@export var spawn_value := 1.0
# @export var spawn_interval := 2.0
var speed_level = 0

var spawn_delay := 0.0
var unit_scene = preload("res://scenes/main/unit.tscn")

func _process(delta):
	spawn_delay += delta * NodeHandler.speed_up_factor

	if $BaseNode.data.upgrades.has(Upgrades.UpgradeType.SPEED):
		speed_level = $BaseNode.data.upgrades[Upgrades.UpgradeType.SPEED]

	$BaseNode.progress = spawn_delay / Values.mine_speed_duration(speed_level)
	if spawn_delay >= Values.mine_speed_duration(speed_level):
		spawn_delay = 0

		if($BaseNode.out_queue.size() == 0):
			var unit: Unit = unit_scene.instantiate()
			unit.value = spawn_value
			unit.dirty = true
			
			$BaseNode.push_unit(unit)
