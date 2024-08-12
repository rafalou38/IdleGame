extends Node2D

@export var spawn_value := 1.0
@export var spawn_interval := 2.0

var spawn_delay := 0.0
var unit_scene = preload("res://scenes/main/unit.tscn")

func _process(delta):
	spawn_delay += delta
	if spawn_delay >= spawn_interval:
		spawn_delay = 0

		var unit: Unit = unit_scene.instantiate()
		unit.value = spawn_value

		$BaseNode.push_unit(unit)
