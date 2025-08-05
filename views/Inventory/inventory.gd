@tool

class_name Inventory
extends Control


var touch_id := -1
var touch_start := Vector2.ZERO
var panel_pos_start := Vector2.ZERO

var target_pos := Vector2.ZERO

var top_pos := -1.0
var bottom_pos := -1.0

var left_pos := -1.0
var right_pos := -1.0

static var open := false
static var dropping := false
static var dirty := false

@onready var hbox = $Panel/VBoxContainer/PanelContainer/ScrollContainer/HBoxContainer

var last_node_count := 0
func _process(_a: float) -> void:
	if dirty:
		for child in hbox.get_children():
			child.dirty = true
		dirty = false
	var allGone = true
	for child in hbox.get_children():
		if child.visible:
			allGone = false
			break

	if allGone && !NodeDisplacement.dragging_node:
		open = false

	if Economy.owned.size() != last_node_count and not $"../Shop".overlayed:
		last_node_count = Economy.owned.size()
		open = true

	if top_pos == -1 or true:
		top_pos = size.y - $Panel.size.y
		bottom_pos = size.y - 16 * 3

		var hbox_rect = hbox.get_global_rect()
		left_pos = (hbox.get_parent().get_global_rect().size.x - hbox_rect.size.x) - 32
		right_pos = 0
	
	$Panel.position.x = 0
	if open:
		$Panel.position.y = lerpf($Panel.position.y, top_pos, 0.1)
	else:
		$Panel.position.y = lerpf($Panel.position.y, bottom_pos, 0.1)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		dropping = false
		if event.pressed:
			var box_rect = $Panel.get_global_rect()
			var container_rect = get_global_rect()
			var hit = event.position.y > box_rect.position.y and event.position.y < container_rect.end.y

			if hit:
				CameraMovement.control_locks.append("inventory")
				touch_id = event.index
				touch_start = event.position
				panel_pos_start = Vector2(hbox.position.x, $Panel.position.y)
		elif event.index == touch_id:
			touch_id = -1
			CameraMovement.control_locks.erase("inventory")
	elif event is InputEventScreenDrag:
		dropping = false
		if NodeDisplacement.dragging_node:
			if event.position.y >= $Panel.global_position.y:
				open = true
				dropping = true
			else:
				open = false
		if event.index == touch_id:
			var delta = touch_start - event.position

			target_pos = Vector2(
				clamp(panel_pos_start.x - delta.x, left_pos, right_pos),
				clamp(panel_pos_start.y - delta.y, top_pos, bottom_pos)
			)

			hbox.position.x = target_pos.x

			open = target_pos.y < (top_pos + bottom_pos) / 2.0
