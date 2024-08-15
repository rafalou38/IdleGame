extends Control

var open := false
var timer := 0

@export var node_handler: NodeHandler

func _ready():
	var anim = $AnimationPlayer.get_animation("slide_in")
	var trackID = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_out = $AnimationPlayer.get_animation("slide_out")
	var trackID_out = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_RESET = $AnimationPlayer.get_animation("RESET")
	var trackID_RESET = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	if trackID != -1 and trackID_out != -1:
		anim.track_set_key_value(trackID, 0, Vector2(get_viewport_rect().size.x, 0))
		anim_out.track_set_key_value(trackID_out, 1, Vector2(get_viewport_rect().size.x, 0))
		anim_RESET.track_set_key_value(trackID_RESET, 0, Vector2(get_viewport_rect().size.x, 0))
	else:
		print("track not found")

	$AnimationPlayer.play("RESET")
	$AnimationPlayer.connect("animation_finished", _anim_finished)

	
	if OS.is_debug_build():
		print("Shop")
		var t = ""
		for i in range(10):
			t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.SHOP, i)) + " "
		print(t)

		print("Mine")
		t = ""
		for i in range(10):
			t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.MINE, i)) + " "
		print(t)

		print("Processor")
		t = ""
		for i in range(40):
			t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.PROCESSOR, i)) + " "
		print(t)

		print("Refinery")
		t = ""
		for i in range(25):
			t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.REFINERY, i)) + " "
		print(t)


func _anim_finished(anim_name):
	if anim_name == "slide_out":
		node_handler.insert_delayed = false

func show_shop():
	node_handler.insert_delayed = true
	open = true
	$AnimationPlayer.play("slide_in")

func hide_shop():
	open = false
	$AnimationPlayer.play("slide_out")


func _handle_button_close():
	hide_shop()

func buy(type: NodeHandler.NodeType):
	node_handler.add_node(type)
	# hide_shop()