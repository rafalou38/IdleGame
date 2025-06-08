extends Node2D

@export var spawn_value := 1.0
@export var spawn_interval := 2.0

var spawn_delay := 0.0
var unit_scene = preload("res://scenes/main/unit.tscn")

func _process(delta):
	spawn_delay += delta * NodeHandler.speed_up_factor

	$BaseNode.progress = spawn_delay / spawn_interval
	if spawn_delay >= spawn_interval:
		spawn_delay = 0


		if($BaseNode.out_queue.size() == 0):
			var unit: Unit = unit_scene.instantiate()
			unit.value = spawn_value
			unit.dirty = true
			
			$BaseNode.push_unit(unit)
