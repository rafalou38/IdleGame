extends Control

@export var upgrade_item_ref: Resource

@export var current_node: GameNode

var is_open = false
var prev_cnt = -1

@onready var unit_list: HBoxContainer = $Control/PanelContainer/VBoxContainer/InputQueue/QueueCOntainer/HB/SC/UnitList
@onready var unit_item_prefab = preload("res://views/upgrade/unit_list_item.tscn")
@onready var upgrades_list: VBoxContainer = $Control/PanelContainer/VBoxContainer/Upgrade/UpgradeContainer/UpgradesList

func _ready() -> void:
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.connect("animation_finished", anim_end)


func _configure():
	if (current_node == null): return ;

	var ui = $Control/PanelContainer/VBoxContainer/Header/node_ui
	ui.icon = Nodes.node_icons(current_node.type)
	ui.color = Nodes.node_color(current_node.type)
	$Control/PanelContainer/VBoxContainer/Header/Heading/Name.text = L.node_name(current_node.type)
	$Control/PanelContainer/VBoxContainer/Header/Heading/Description.text = L.node_desc(current_node.type)
	$Control/PanelContainer/VBoxContainer/Processing/ProgressBar.value = current_node.progress * 100
	$Control/PanelContainer/VBoxContainer/InputQueue/QueueCOntainer/HB/Counter/Label.text = "0"

func _configure_upgrades():
	for c in upgrades_list.get_children():
		upgrades_list.remove_child(c)
		c.queue_free()

	for upgrade_id in Economy.research.keys():
		#var r = Economy.research[upgrade_id]
		var node_type := Upgrades.node_type_from_id(upgrade_id)
		var research_type := Upgrades.upgrade_type_from_id(upgrade_id)

		if (node_type == current_node.type
			&& research_type != Upgrades.UpgradeType.UNLOCK
			#&& (r.state == ResearchTreeItem.State.BOUGHT || (r.level > 1))
		):
			var item = upgrade_item_ref.instantiate()
			item.node = current_node
			item.upgrade_type = research_type

			upgrades_list.add_child(item)

func _process(_delta: float) -> void:
	if is_open:
		_sync()

func _sync():
	if (current_node == null): return
	$Control/PanelContainer/VBoxContainer/Processing/ProgressBar.value = current_node.progress * 100
	if prev_cnt != current_node.input_queue.size():
		$Control/PanelContainer/VBoxContainer/InputQueue/QueueCOntainer/HB/Counter/Label.text = str(current_node.input_queue.size())
		prev_cnt = current_node.input_queue.size()
		for c in unit_list.get_children():
			unit_list.remove_child(c)
			c.queue_free()
		for unit in current_node.input_queue:
			var c = unit_item_prefab.instantiate()

			unit_list.add_child(c)

			var fake_unit: Unit = c.get_child(0)
			fake_unit.type = unit.type
			fake_unit.value = unit.value
			fake_unit.dirty = true
			fake_unit.active = false
			fake_unit.sync()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if (event.pressed):
			var fg_rect: Rect2 = $Control/PanelContainer.get_global_rect()

			if (!Util.collide_rect(fg_rect, event.position)):
				close()

func anim_end(anim_name):
	if (is_open == false && anim_name == "open"):
		CameraMovement.control_locks.erase("UpgradeMenu")

func open(node: GameNode):
	current_node = node
	if (is_open): return
	else:
		is_open = true
		_sync()
		_configure()
		_configure_upgrades()
		CameraMovement.control_locks.append("UpgradeMenu")
		$AnimationPlayer.play("open")

func close():
	if (!is_open): return
	else:
		is_open = false
		
		$AnimationPlayer.play_backwards("open")
