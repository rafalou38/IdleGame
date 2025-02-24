class_name Economy
extends Node2D

static var money := 20.0

static var research := {

}
static var active_research := ""

static var owned: Array[NodeData] = []
static var new_save := false


static var SAVE_FILE := "res://economy.save.json"

static func save():
	var serialized_economy = {
		"research": research,
		"owned": owned.map(func(e): return e.serialize()),
		"money": money
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
	owner.find_child("Shop").buy(NodeData.NodeType.SHOP)
	owner.find_child("Shop").buy(NodeData.NodeType.MINE)

func _process(_delta: float) -> void:
	if (new_save):
		new_save = false
		start_new_save()
		
	if(active_research == ""):
		for r in research:
			if(research[r].state == ResearchTreeItem.State.RESEARCHING):
				active_research = r

func _ready() -> void:
	load_save()
	owner.find_child("Node Handler").load_nodes()

static var _prev_money := 0.0
static var _prev_money_time := 0.0
static var _dvm := 0.0
static func var_money() -> float:
	var now = Time.get_unix_time_from_system()

	if _prev_money > money:
		_prev_money = money
		_prev_money_time = now
	elif _prev_money < money:
		var nv := lerpf(_dvm, (money - _prev_money) / (now - _prev_money_time), 0.8)
		# if _dvm > 1 and nv > _dvm * 1.8: _dvm = _dvm * 1.8
		# else: _dvm = nv

		_dvm = nv

		_prev_money_time = now
		_prev_money = money

	return _dvm

func _notification(what):
	if what in [NOTIFICATION_WM_CLOSE_REQUEST, NOTIFICATION_WM_GO_BACK_REQUEST, NOTIFICATION_WM_WINDOW_FOCUS_OUT]:
		save()
