@tool
class_name ResearchTreeItem
extends Control

enum State {
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
@export var state := State.AVAILABLE
@export var dirty := false
@export var line_texture: Texture2D

@export var targets: Array[ResearchTreeItem] = []

func refresh_state() -> void:
	match state:
		State.HIDDEN:
			visible = false
		State.LOCKED:
			visible = true
			$container/VBoxContainer/Label.visible = true
			$container/VBoxContainer/HBoxContainer.visible = false
			$container/VBoxContainer/Button.visible = false
		State.AVAILABLE:
			visible = true
			$container/VBoxContainer/Label.visible = false
			$container/VBoxContainer/HBoxContainer.visible = true
			$container/VBoxContainer/Button.visible = true
		State.RESEARCHING:
			visible = true
			$container/VBoxContainer/Label.visible = false
			$container/VBoxContainer/HBoxContainer.visible = true
			$container/VBoxContainer/Button.visible = false
		State.BOUGHT:
			visible = true
			$container/VBoxContainer/Label.visible = false
			$container/VBoxContainer/HBoxContainer.visible = true
			$container/VBoxContainer/Button.visible = false

	
	for c in $Out.get_children():
		$Out.remove_child(c)

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

		line.origin = $Out
		line.target = target.find_child("In")


		if target.state == State.LOCKED:
			line.texture = line_texture
		else:
			line.texture = null
		

		line.visible = target.state != State.HIDDEN
		
		$Out.add_child(line)

		target.refresh_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var logo = $container/VBoxContainer/HBoxContainer/Logo
	logo.get_child(0).texture = icon

	var box = logo.get_theme_stylebox("panel", "Panel").duplicate();
	box.bg_color = research_color
	logo.add_theme_stylebox_override("panel", box)

	$container/VBoxContainer/HBoxContainer/Title/Name.text = research_name
	$container/VBoxContainer/HBoxContainer/Title/Description.text = description

	$container/VBoxContainer/Button/HBoxContainer/Label.text = Util.number_to_human(price)

	if $Out.get_child_count() != targets.size() or dirty:
		dirty = false
		refresh_state()



func _on_buy_button_pressed() -> void:
	if state != State.AVAILABLE: return

	state = State.BOUGHT

	dirty = true