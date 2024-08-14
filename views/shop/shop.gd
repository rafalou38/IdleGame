extends Control

var open := false
var timer := 0

@export var node_handler: NodeHandler

func _ready():
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
	if anim_name == "slide_in" and open == false:
		node_handler.insert_delayed = false

func show_shop():
	node_handler.insert_delayed = true
	open = true
	$AnimationPlayer.play("slide_in")

func hide_shop():
	open = false
	$AnimationPlayer.play_backwards("slide_in")


func _handle_button_close():
	hide_shop()

func buy(type: NodeHandler.NodeType):
	node_handler.add_node(type)
	# hide_shop()