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


@export var id := ""
@export var icon: Texture2D = null
@export var research_color := Color(0, 0, 0, 1)
@export var research_name := ""
@export_multiline var description := ""
@export var price := 0
@export var state := State.NULL
@export var dirty := false
@export var line_texture: Texture2D

@export var duration := 10.0

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
var research_start_time := 0.0

func _ready():
	prev_state = State.NULL
	animator.speed_scale = 1000
	visible = false
	$container.modulate.a = 0
	call_deferred("sync_size")


	if (Economy.research.has(id)):
		state = Economy.research[id]["state"]
		research_start_time = Economy.research[id]["research_start_time"]
	dirty = true

func sync_size():
	$container/VBoxContainer/ResearchBox/Panel.size = $container/VBoxContainer/ResearchBox.size
	$container/VBoxContainer/ResearchBox/VBoxContainer.size = $container/VBoxContainer/ResearchBox.size

func refresh_state() -> void:
	if state == prev_state: return
	if prev_state != State.NULL: animator.speed_scale = 2

	if (Economy.research.has(id)):
		Economy.research[id]["state"] = state;
	else:
		Economy.research[id] = {
			"state": state,
			"research_start_time": research_start_time
		}

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		animator.play("RESET")
		visible = true
		$container.modulate.a = 1

	var logo = $container/VBoxContainer/HBoxContainer/Logo
	logo.get_child(0).texture = icon

	var box = logo.get_theme_stylebox("panel", "Panel").duplicate();
	box.bg_color = research_color
	logo.add_theme_stylebox_override("panel", box)

	$container/VBoxContainer/HBoxContainer/Title/Name.text = research_name
	$container/VBoxContainer/HBoxContainer/Title/Description.text = description
	if (price == 0):
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.text = "FREE"
	else:
		$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.text = Util.number_to_human(price)

	var remaining = duration - (Time.get_unix_time_from_system() - research_start_time)
	var progress = 1 - remaining / duration
	if research_start_time > 0 and remaining < 0:
		state = State.BOUGHT
		dirty = true
	else:
		$container/VBoxContainer/ResearchBox/VBoxContainer/Label2.text = str(abs(round(remaining))) + "s"
		$container/VBoxContainer/ResearchBox/Panel.size.x = $container/VBoxContainer/ResearchBox.size.x * progress

	if dirty or targets_b.size() + targets_r.size() + targets_t.size() + targets_l.size() != point_b.get_child_count():
		if Engine.is_editor_hint():
			prev_state = State.NULL

		dirty = false
		refresh_state()


func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and event is InputEventKey:
		if event.pressed and event.keycode == KEY_TAB:
			if state == State.RESEARCHING:
				state = State.BOUGHT
		
		dirty = true


func _on_buy_button_pressed() -> void:
	if state != State.AVAILABLE: return

	state = State.RESEARCHING
	research_start_time = Time.get_unix_time_from_system()

	dirty = true
