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


@export var icon: Texture2D = null
@export var research_color := Color(0, 0, 0, 1)
@export var research_name := ""
@export var description := ""
@export var price := 0
@export var state := State.NULL
@export var dirty := false
@export var line_texture: Texture2D

@export var targets: Array[ResearchTreeItem] = []
@onready var out_point := $container/ConnectorBox/Control3/Control/Out
@onready var in_point := $container/ConnectorBox/Control/Control/In
@onready var animator := $AnimationPlayer

var prev_state : State = State.NULL

func _ready():
	prev_state = State.NULL
	call_deferred("sync_size")

func sync_size():
	$container/VBoxContainer/ResearchBox/Panel.size = $container/VBoxContainer/ResearchBox.size
	$container/VBoxContainer/ResearchBox/VBoxContainer.size = $container/VBoxContainer/ResearchBox.size

func refresh_state() -> void:
	if state == prev_state: return
	if prev_state == State.NULL: animator.speed_scale = 100
	else: animator.speed_scale = 2

	match state:
		State.HIDDEN:
			visible = false
		State.LOCKED:
			visible = true
			animator.play("appear")
		State.AVAILABLE:
			animator.play("unlock")
		State.RESEARCHING:
			animator.play("start_research")
		State.BOUGHT:
			animator.play("bought")
	
	for c in out_point.get_children():
		out_point.remove_child(c)

	for target in targets:
		if target == null: continue

		match state:
			State.LOCKED:
				target.state = State.HIDDEN
			State.AVAILABLE:
				target.state = State.LOCKED
			State.RESEARCHING:
				target.state = State.LOCKED
			State.BOUGHT:
				target.state = State.AVAILABLE
		

		var line = ResearchLine.new()
		var path = Path2D.new()

		line.add_child(path)
		line.path = path

		line.origin = out_point
		line.target = target.in_point


		if target.state == State.LOCKED:
			line.texture = line_texture
		else:
			line.texture = null
		

		line.visible = target.state != State.HIDDEN
		
		out_point.add_child(line)

		target.refresh_state()
	

	prev_state = state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var logo = $container/VBoxContainer/HBoxContainer/Logo
	logo.get_child(0).texture = icon

	var box = logo.get_theme_stylebox("panel", "Panel").duplicate();
	box.bg_color = research_color
	logo.add_theme_stylebox_override("panel", box)

	$container/VBoxContainer/HBoxContainer/Title/Name.text = research_name
	$container/VBoxContainer/HBoxContainer/Title/Description.text = description

	$container/VBoxContainer/Button/CenterContainer/HBoxContainer/Label.text = Util.number_to_human(price)

	if out_point.get_child_count() != targets.size() or dirty:
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

	dirty = true