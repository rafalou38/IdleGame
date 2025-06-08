@tool
class_name ResearchTreeItem
extends Control

enum State {
	NULL,
	HIDDEN,
	LOCKED,
	AVAILABLE,
	RESEARCHING,
	BOUGHT
}
enum Direction {
	TOP,
	RIGHT,
	BOTTOM,
	LEFT
}

@export var type: Upgrades.UpgradeType = Upgrades.UpgradeType.UNLOCK
@export var node_type: Nodes.NodeType = Nodes.NodeType.SHOP
@export var level := 1


@export var icon: Texture2D = null
@export var research_color := Color(0, 0, 0, 1)

@export var id := ""
@export var research_name := ""
@export_multiline var description := ""

# ---

@export var price := 0
@export var price_rp := 0
@export var state := State.NULL
@export var line_texture: Texture2D

@export var targets_t: Array[ResearchTreeItem] = []
@export var targets_r: Array[ResearchTreeItem] = []
@export var targets_b: Array[ResearchTreeItem] = []
@export var targets_l: Array[ResearchTreeItem] = []


@onready var point_b := $container/ConnectorBox/Control3/Control/bottom
@onready var point_r := $container/ConnectorBox/Control2/CenterContainer/Control2/right
@onready var point_t := $container/ConnectorBox/Control/Control/top
@onready var point_l := $container/ConnectorBox/Control2/CenterContainer2/Control2/left
@onready var animator := $AnimationPlayer

var prev_state: State = State.NULL

func _ready():
	animator.speed_scale = 1000
	visible = false
	$container.modulate.a = 0
	id = Upgrades.upgrade_id(node_type, type)

	prev_state = State.NULL
	# Restore state
	if Economy.research.has(id):
		if type == Upgrades.UpgradeType.UNLOCK or type == Upgrades.UpgradeType.RP_MARKET:
			state = Economy.research[id]["state"]
			level = 0
		else:
			if Economy.research[id]["state"] == State.BOUGHT:
				level = Economy.research[id]["level"] + 1
				state = State.AVAILABLE
			else:
				print(Economy.research[id])
				level = Economy.research[id]["level"]
				state = Economy.research[id]["state"]

	call_deferred("_config_ui")
	call_deferred("refresh_state")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		id = Upgrades.upgrade_id(node_type, type)
		_config_ui()
		# animator.play("RESET")
		visible = true
		$container.modulate.a = 1
	 
	_sync_progress()

	$container/VBoxContainer/ResearchBox/Panel.size = $container/VBoxContainer/ResearchBox.size
	$container/VBoxContainer/ResearchBox/VBoxContainer.size = $container/VBoxContainer/ResearchBox.size

	if targets_b.size() + targets_r.size() + targets_t.size() + targets_l.size() != point_b.get_child_count():
		if Engine.is_editor_hint():
			prev_state = State.NULL
		refresh_state()

func _config_ui():
	if type == Upgrades.UpgradeType.UNLOCK:
		description = L.node_desc(node_type)
		research_name = L.node_name(node_type)
		icon = Nodes.node_icons(node_type)
		research_color = Nodes.node_color(node_type)
	else:
		description = L.upgrade_desc(type)
		research_name = L.upgrade_name(type) + " " + Util.number_to_roman(level) + ""
		icon = Upgrades.upgrade_icons(type)
		research_color = Color("#151515")

	$container/VBoxContainer/ResearchBox/Panel.size = $container/VBoxContainer/ResearchBox.size
	$container/VBoxContainer/ResearchBox/VBoxContainer.size = $container/VBoxContainer/ResearchBox.size


	var logo = $container/VBoxContainer/HBoxContainer/Logo
	logo.get_child(0).texture = icon

	var box = logo.get_theme_stylebox("panel", "Panel").duplicate();
	box.bg_color = research_color
	logo.add_theme_stylebox_override("panel", box)

	$container/VBoxContainer/HBoxContainer/Title/Name.text = research_name
	$container/VBoxContainer/HBoxContainer/Title/Description.text = description

	$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.text = Util.number_to_human(price)
	$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label2.text = Util.number_to_human(price_rp)

	# Price display
	if (price == 0 and price_rp == 0):
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.text = "FREE"
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.visible = true

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control.visible = false

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Spacer.visible = false
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control2.visible = false
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label2.visible = false
	elif (price == 0):
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.visible = false
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control.visible = false

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Spacer.visible = false

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control2.visible = true
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label2.visible = true
	elif (price_rp == 0):
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.visible = true
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control.visible = true

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Spacer.visible = false

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control2.visible = false
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label2.visible = false
	else:
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.visible = true
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control.visible = true

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Spacer.visible = true

		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Control2.visible = true
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label2.visible = true

func _sync_progress():
	if Engine.is_editor_hint() or not Economy.research.has(id):
		return
	
	if state == State.RESEARCHING:
		# Update progress bar
		var spent : float = min(price, Economy.research[id]["spent"])
		var spent_rp : float = min(price_rp, Economy.research[id]["spent_rp"])

		var progress := (spent + spent_rp)/(price+price_rp)

		var text :=  " "
		if (price > 0):
			text = text + Util.number_to_human(spent) + "/" + Util.number_to_human(price)
			if (price_rp > 0): text += " "
		if(price_rp > 0):
			text += Util.number_to_human(spent_rp) + "/" + Util.number_to_human(price_rp)
		
		$container/VBoxContainer/ResearchBox/VBoxContainer/Label2.text = text
		if(progress >= 0 and progress <= 1):
			$container/VBoxContainer/ResearchBox/Panel.size.x = $container/VBoxContainer/ResearchBox.size.x * progress
			$container/VBoxContainer/ResearchBox/Panel.position.x = 0
			$container/VBoxContainer/ResearchBox/Panel.position.y = 0

		if spent >= price and spent_rp >= price_rp:
			_end_research()

func _end_research():
	if type == Upgrades.UpgradeType.UNLOCK or type == Upgrades.UpgradeType.RP_MARKET:
		state = State.BOUGHT
		Economy.research[id]["state"] = State.BOUGHT
		Economy.active_research = ""
		BottomBar.ping_research += 1
		BottomBar.ping_shop += 1
	else:
		state = State.AVAILABLE
		Economy.research[id]["state"] = State.AVAILABLE
		level =  Economy.research[id]["level"] + 1
		Economy.active_research = ""
		BottomBar.ping_research += 1
		animator.play("reset")
	_config_ui()
	refresh_state()


func _start_research():
	Economy.active_research = id
	state = State.RESEARCHING
	Economy.research[id] = {
		"spent_rp": 0,
		"price": price,
		"spent": 0,
		"price_rp": price_rp,
		"state": State.RESEARCHING,
		"level": level
	}
	refresh_state()


func refresh_state() -> void:
	if prev_state != State.NULL: animator.speed_scale = 2

	match state:
		State.NULL:
			visible = false
			$container.modulate.a = 0
		State.HIDDEN:
			visible = false
			$container.modulate.a = 0
		State.LOCKED:
			visible = true
			$container.modulate.a = 0
			animator.play("appear")
		State.AVAILABLE:
			visible = true
			animator.play("unlock")
			$container.modulate.a = 1
		State.RESEARCHING:
			visible = true
			animator.play("start_research")
			$container.modulate.a = 1
		State.BOUGHT:
			visible = true
			animator.play("bought")
			$container.modulate.a = 1
	
	for c in point_b.get_children():
		point_b.remove_child(c)

	for target in targets_b:
		if target != null:
			check_target(target, point_b, target.point_t)
	for target in targets_r:
		if target != null:
			check_target(target, point_r, target.point_l)
	for target in targets_t:
		if target != null:
			check_target(target, point_t, target.point_b)
	for target in targets_l:
		if target != null:
			check_target(target, point_l, target.point_r)
	
	prev_state = state

func check_target(target: ResearchTreeItem, origin_point: Node, target_point: Node) -> void:
	match state:
		State.LOCKED:
			target.state = State.HIDDEN
		State.AVAILABLE:
			target.state = State.LOCKED
		State.RESEARCHING:
			target.state = State.LOCKED
		State.HIDDEN:
			target.state = State.HIDDEN
		State.BOUGHT:
			if (target.state not in [State.BOUGHT, State.RESEARCHING]):
				target.state = State.AVAILABLE
	

	var line = ResearchLine.new()
	var path = Path2D.new()

	line.add_child(path)
	line.path = path


	line.origin = origin_point
	line.target = target_point


	if target.state == State.LOCKED or target.state == State.HIDDEN:
		line.texture = line_texture
	else:
		line.texture = null
	

	line.visible = (target.state != State.HIDDEN) or Engine.is_editor_hint()
	
	point_b.add_child(line)

	target.refresh_state()


func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event is InputEventKey:
		if event.pressed and event.keycode == KEY_TAB:
			if state == State.RESEARCHING:
				state = State.BOUGHT


func _on_buy_button_pressed() -> void:
	if state != State.AVAILABLE: return
	_start_research()
