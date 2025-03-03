extends Label


@export_multiline var texts: Array[String] = []

@export var curent_dialogue := 0
var letter := 0
@export var writing := false
@export var finished := false

var first_delay = 2

var locked = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

var delay := 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Economy.tutorial_finished:
		return

	if (curent_dialogue == 0):
		Inventory.open = false
	if (curent_dialogue == 2):
		# Drag out
		Inventory.open = true
		locked = false
		for node in Economy.owned:
			if not node.placed:
				locked = true

		if not locked:
			curent_dialogue += 1
			letter = 0
		

	if (curent_dialogue == 3):
		locked = true
		if Economy.money > 0: 
			locked = false
			curent_dialogue += 1
			letter = 0


	if(first_delay > 0):
		first_delay -= delta
		return

	var line = texts[curent_dialogue].split()
	if line.size() == 1:
		finished = true

	if letter < line.size():

		delay += delta

		if (delay > 0.08 * randf()):
			letter += 1
			text = "".join(line.slice(0, letter))

			delay = 0

			if letter < line.size() and line[letter] == "\n":
				delay = -0.25
		writing = true
	else:
		writing = false

	
	
	


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not locked:
		if event.pressed:
			if letter < texts[curent_dialogue].length():
				letter = texts[curent_dialogue].length() - 1
			elif curent_dialogue < texts.size() - 1:
				curent_dialogue = curent_dialogue + 1
				letter = 0

func end():
	curent_dialogue = texts.size() - 1
