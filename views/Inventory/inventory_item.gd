@tool
extends Control

@export var node_type: NodeHandler.NodeType = NodeHandler.NodeType.SHOP
@export var count := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ref = NodeHandler.node_ref_by_type[node_type]
	if ref == null: return
	var node =  ref.instantiate()
	var base_ui = node.find_child("node_ui")

	$node_ui.icon = base_ui.icon
	$node_ui.hue = base_ui.hue

	$PanelContainer/Label.text = str(count)
	$Label.text = base_ui.displayName

	node.queue_free()

func _process(delta: float) -> void:
	if count <= 0:
		visible = false
