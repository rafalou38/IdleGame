class_name Economy
extends Node2D

static var money := 20.0

static var research := {

}
static var active_research := ""

static var owned: Array[NodeData] = []
static var new_save := false
static var tutorial_finished := false

static var SAVE_FILE := "user://economy.save.json"

static func save():
	var serialized_research = {}
	for id in research:
		serialized_research[id] = {
			"spent": research[id]["spent"],
			"spent_rp": research[id]["spent_rp"],
			"price": research[id]["price"],
			"price_rp": research[id]["price_rp"],
			"state": research[id]["state"],
			"level": research[id]["level"]
		}

	var serialized_economy = {
		"research": serialized_research,
		"owned": owned.map(func(e): return e.serialize()),
		"money": money,
		"tutorial_finished": tutorial_finished
	}


	var json_string = JSON.stringify(serialized_economy)

	var save_file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	save_file.store_line(json_string)
	print("Game sucessfully saved")

static func load_save():
	if not FileAccess.file_exists(SAVE_FILE):
		new_save = true
		return
	
	var save_file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var json_string = save_file.get_line()
	var json = JSON.new()

	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return

	# Get the data from the JSON object.
	var serialized_economy = json.data
	money = serialized_economy["money"]
	tutorial_finished = serialized_economy["tutorial_finished"]
	for r_id in serialized_economy["research"]:
		research[r_id] = serialized_economy["research"][r_id]
	

	for serialized_node in serialized_economy.owned:
		var data := NodeData.deserialize(serialized_node)
		owned.append(data)

func start_new_save():
	print("new save")
	money = 0
	owned.clear()
	research.clear()
	owner.find_child("Shop").buy(Nodes.NodeType.SHOP)
	owner.find_child("Shop").buy(Nodes.NodeType.MINE)

func _process(_delta: float) -> void:
	if (new_save):
		new_save = false
		start_new_save()
		
	if (active_research == ""):
		for r in research:
			if research[r]["state"] == ResearchTreeItem.State.RESEARCHING:
				active_research = r

	refresh_dfs()
func _init() -> void:
	load_save()

func _ready() -> void:
	owner.find_child("Node Handler").load_nodes()

static var _dvm := 0.0
static func var_money() -> float:
	return _dvm


var dfs_history = []

func cheat():
	money += 10
	money *= 2
	if active_research != "":
		research[active_research]["spent"] += 100
		research[active_research]["spent_rp"] += 100

func refresh_dfs():
	dfs_history = []
	_dvm = 0
	var nodes = $"../Home/Node Handler".nodes
	for node in nodes:
		if (node.type == Nodes.NodeType.MINE):
			_dvm += dfs(node, 0, 0)

func dfs(root: GameNode, rate: float, value: float):
	if dfs_history.has(root.data.id):
		return 0
	dfs_history.append(root.data.id)

	match root.type:
		Nodes.NodeType.MINE:
			value = root.get_parent().spawn_value
			rate = Values.mine_speed_duration(root.get_parent().speed_level)
		Nodes.NodeType.PROCESSOR:
			value += Values.process_value_increase(root.get_parent().value_level)
			rate = max(rate, Values.process_speed_duration(root.get_parent().speed_level))
		Nodes.NodeType.LAB:
			value = 0
		Nodes.NodeType.SHOP:
			return value / rate


	var cnn = root.data.outbound_connections
	var out := 0.0
	for cn in cnn:
		out += dfs(cn.toNode, rate, value)
	return out

func _notification(what):
	if what in [NOTIFICATION_WM_CLOSE_REQUEST, NOTIFICATION_WM_GO_BACK_REQUEST, NOTIFICATION_WM_WINDOW_FOCUS_OUT]:
		save()
