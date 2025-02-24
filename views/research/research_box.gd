extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("slide_out")

var current := "slide_out"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Economy.active_research == ""):
		if (current != "slide_out"):
			current = "slide_out"
			$AnimationPlayer.play("slide_out")
		return
	else:
		if (current != "slide_in"):
			current = "slide_in"
			$AnimationPlayer.play("slide_in")


	var research = Economy.research[Economy.active_research]


	var spent: float = min(research["price"], research["spent"])
	var spent_rp: float = min(research["price_rp"], research["spent_rp"])

	var progress = (spent + spent_rp) / (research["price"] + research["price_rp"])

	$Container/PanelContainer/VBoxContainer/Label.text = research["name"]
	$Container/Panel/TextureRect.texture = research["icon"]
	$Container/Panel/TextureRect.expand_mode = TextureRect.ExpandMode.EXPAND_IGNORE_SIZE

	var box = $Container/Panel.get_theme_stylebox("panel", "PanelContainer");
	box.bg_color = research["color"]

	$Container/PanelContainer/VBoxContainer/HBoxContainer/Label.text = str(spent) + "/" + str(research["price"])
	$Container/PanelContainer/VBoxContainer/HBoxContainer/Label2.text = str(spent_rp) + "/" + str(research["price_rp"])

	$Container/ProgressBar.value = progress * 100


	if (owner.find_child("BottomBar").focused in ["home"]):
		if visible == false:
			await get_tree().create_timer(0.5).timeout
			visible = true
	else:
		visible = false
