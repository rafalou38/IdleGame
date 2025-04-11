@tool
extends Control

var open := false
static var overlayed := false
var timer := 0

@export var node_handler: NodeHandler

func _ready():
	sync_dims()

	$AnimationPlayer.play("RESET")
	$AnimationPlayer.connect("animation_finished", _anim_finished)

	if OS.is_debug_build():
		Prices.test_prices()

func _process(_delta):
	sync_dims()

func sync_dims():
	size = $"..".size
	$PanelContainer.size = size

	var anim = $AnimationPlayer.get_animation("slide_in")
	var trackID = anim.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_out = $AnimationPlayer.get_animation("slide_out")
	var trackID_out = anim_out.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	var anim_RESET = $AnimationPlayer.get_animation("RESET")
	var trackID_RESET = anim_RESET.find_track("PanelContainer:position", Animation.TYPE_VALUE)

	if trackID != -1 and trackID_out != -1:
		anim.track_set_key_value(trackID, 0, Vector2(size.x, 0))
		anim_out.track_set_key_value(trackID_out, 1, Vector2(size.x, 0))
		anim_RESET.track_set_key_value(trackID_RESET, 0, Vector2(size.x, 0))
	else:
		print("track not found")

func _anim_finished(anim_name):
	if anim_name == "slide_out":
		overlayed = false

func show_shop():
	overlayed = true
	open = true
	$AnimationPlayer.play("slide_in")
	CameraMovement.control_locks.append("shop")

func hide_shop():
	open = false
	$AnimationPlayer.play("slide_out")
	CameraMovement.control_locks.erase("shop")


func _handle_button_close():
	hide_shop()

func buy(type: NodeData.NodeType):
	# node_handler.add_node(type)
	var data := NodeData.new()
	data.id = randi()
	data.type = type
	data.placed = false
	data.position = Vector2(0,0)
	data.outbound_connections = []
	Economy.owned.append(data)

	BottomBar.ping_home += 1
