extends Control

@export var type: NodeData.NodeType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if (event.pressed):
			# var touch_position: Vector2 = Util.screen_to_world(get_viewport(), event.position)


			var bg_rect: Rect2 = $TextureRect.get_global_rect()
			var fg_rect: Rect2 = $Control/PanelContainer.get_global_rect()

			if(!Util.collide_rect(fg_rect, event.position)):# && _collide(bg_rect, event.position)):
				print("farewell")
				$AnimationPlayer.play_backwards("open")
