extends Control

var open := false
var timer := 0

@export var node_handler: NodeHandler

func _ready():
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.connect("animation_finished", _anim_finished)

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