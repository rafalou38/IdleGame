extends Control

@export var node_type: NodeData.NodeType = NodeData.NodeType.SHOP
@export var count := 1

var long_press_id := -1
var long_press_start_time := -1
var long_press_start_point := Vector2.ZERO
var long_press_current_point := Vector2.ZERO

var last_node_count = -1
var dirty = true

# Called when the node enters the scene tree for the first time.
func refresh() -> void:
	var ref = NodeHandler.node_ref_by_type[node_type]
	if ref == null: return
	var node = ref.instantiate()
	var base_ui = node.find_child("node_ui")

	$node_ui.icon = base_ui.icon
	$node_ui.hue = base_ui.hue
	$node_ui.color = base_ui.color

	$PanelContainer/Label.text = str(count)
	$Label.text = base_ui.displayName

	node.queue_free()

func _ready() -> void:
	refresh()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed and long_press_id == -1:
			var rect = get_global_rect()

			if rect.has_point(event.position) and count > 0:
				long_press_id = event.index
				long_press_start_time = Time.get_ticks_msec()
				long_press_start_point = event.position
				long_press_current_point = event.position

		elif not event.pressed and long_press_id == event.index:
			long_press_id = -1
	elif event is InputEventScreenDrag:
		if long_press_id == event.index:
			long_press_current_point = event.position


func _process(_delta: float) -> void:
	if long_press_id != -1 and Time.get_ticks_msec() - long_press_start_time > 200 and long_press_current_point.distance_to(long_press_start_point) < 10:
		take_out()
		long_press_id = -1

	if last_node_count != Economy.owned.size() or dirty:
		last_node_count = Economy.owned.size()
		dirty = false

		count = 0
		for node in Economy.owned:
			if node["type"] == node_type and not node["placed"]:
				count += 1
		
		refresh()

	if count <= 0:
		visible = false
	else:
		visible = true
	
func take_out() -> void:
	var nodes = Economy.owned.filter(func(node): return node["type"] == node_type and not node["placed"])
	if(nodes.size() == 0): 
		print("This should not happen")
		print("TakeOut from ", name)

		return

	var first = nodes[0]

	first["placed"] = true
	
	owner.owner.find_child("Node Handler").drag_node(first, long_press_id, Util.screen_to_world(get_viewport(), long_press_current_point))

	dirty = true

	# owner.open = false
	owner.touch_id = -1

	CameraMovement.control_locks.erase("inventory")
	CameraMovement.control_locks.append("NodeDisplacement/" + str(long_press_id))
	
