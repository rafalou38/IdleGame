extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.speed_scale = 100
	$AnimationPlayer.play("slide_out")

var current := "slide_out"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Economy.active_research == ""):
		if (current != "slide_out"):
			current = "slide_out"
			$AnimationPlayer.speed_scale = 1
			$AnimationPlayer.play("slide_out")
		return
	else:
		if (current != "slide_in"):
			current = "slide_in"
			$AnimationPlayer.speed_scale = 1
			$AnimationPlayer.play("slide_in")

	if Economy.active_research not in Economy.research: return

	var research = Economy.research[Economy.active_research]
	# print(research)
	var research_type = Upgrades.upgrade_type_from_id(Economy.active_research)
	var research_node = Upgrades.node_type_from_id(Economy.active_research)
	var research_level = Economy.research[Economy.active_research].get("level", 0)
	# if not Economy.research.has("price"): return

	var spent: float = min(research["price"], research["spent"])
	var spent_rp: float = min(research["price_rp"], research["spent_rp"])

	var progress = (spent + spent_rp) / (research["price"] + research["price_rp"])

	if research_type == Upgrades.UpgradeType.UNLOCK:
		$Container/PanelContainer/VBoxContainer/Label.text = L.node_name(research_node)
		$Container/Panel/TextureRect.texture = Nodes.node_icons(research_node)
	else:
		$Container/PanelContainer/VBoxContainer/Label.text = L.upgrade_name(research_type) + " " + Util.number_to_roman(research_level) + ""
		$Container/Panel/TextureRect.texture = Upgrades.upgrade_icons(research_type)

	$Container/Panel/TextureRect.expand_mode = TextureRect.ExpandMode.EXPAND_IGNORE_SIZE

	var box = $Container/Panel.get_theme_stylebox("panel", "PanelContainer");
	box.bg_color = Nodes.node_color(research_node)

	$Container/PanelContainer/VBoxContainer/HBoxContainer/Label.text = Util.number_to_human(spent) + "/" + Util.number_to_human(research["price"])
	$Container/PanelContainer/VBoxContainer/HBoxContainer/Label2.text = Util.number_to_human(spent_rp) + "/" + Util.number_to_human(research["price_rp"])

	$Container/ProgressBar.value = progress * 100

	if (owner.find_child("BottomBar").focused in ["home"]):
		if visible == false:
			await get_tree().create_timer(0.5).timeout
			visible = true
	else:
		visible = false
