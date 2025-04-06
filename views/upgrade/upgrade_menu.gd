extends Control

@export var current_node: GameNode

var is_open = false
var prev_cnt = -1

@onready var unit_list: HBoxContainer = $Control/PanelContainer/VBoxContainer/InputQueue/QueueCOntainer/HB/SC/UnitList
@onready var unit_item_prefab = preload("res://views/upgrade/unit_list_item.tscn")

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.connect("animation_finished", anim_end)

func _process(_delta: float) -> void:
	_sync()

func anim_end(anim_name):
	if (is_open == false && anim_name == "open"):
		CameraMovement.control_locks.erase("UpgradeMenu")

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if (event.pressed):
			# var touch_position: Vector2 = Util.screen_to_world(get_viewport(), event.position)
			# var bg_rect: Rect2 = $TextureRect.get_global_rect()

			var fg_rect: Rect2 = $Control/PanelContainer.get_global_rect()

			if (!Util.collide_rect(fg_rect, event.position)): # && _collide(bg_rect, event.position)):
				close()

func _sync():
	if (current_node == null): return
	var base_ui = current_node.find_child("node_ui")
	var ui = $Control/PanelContainer/VBoxContainer/Header/node_ui
	
	
	$Control/PanelContainer/VBoxContainer/InputQueue/QueueCOntainer/HB/Counter/Label.text = str(current_node.input_queue.size())
	if prev_cnt != current_node.input_queue.size():
		prev_cnt = current_node.input_queue.size()
		for c in unit_list.get_children():
			unit_list.remove_child(c)
			c.queue_free()
		for unit in current_node.input_queue:
			var c = unit_item_prefab.instantiate()

			unit_list.add_child(c)

			var fake_unit : Unit = c.get_child(0)
			fake_unit.type = unit.type
			fake_unit.value = unit.value

			fake_unit.sync()

	ui.icon = base_ui.icon
	ui.hue = base_ui.hue
	ui.color = base_ui.color
	$Control/PanelContainer/VBoxContainer/Header/Heading/Name.text = base_ui.displayName
	$Control/PanelContainer/VBoxContainer/Header/Heading/Description.text = L.node_desc[current_node.type]
	$Control/PanelContainer/VBoxContainer/Processing/ProgressBar.value = current_node.progress * 100

	
func open(node: GameNode):
	current_node = node
	if (is_open): return
	else:
		is_open = true
		_sync()
		CameraMovement.control_locks.append("UpgradeMenu")
		$AnimationPlayer.play("open")

func close():
	if (!is_open): return
	else:
		is_open = false
		
		$AnimationPlayer.play_backwards("open")
