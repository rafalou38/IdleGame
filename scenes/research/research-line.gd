@tool
class_name ResearchLine
extends Line2D

var path: Path2D
var origin: Node
var target: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.visible = false

	path.curve = Curve2D.new()
	path.curve.add_point(Vector2.ZERO)
	path.curve.add_point(Vector2.ZERO)

	default_color = Color.from_string("#2d2d2d", Color.WHITE)
	width = 8
	texture_repeat = TextureRepeat.TEXTURE_REPEAT_ENABLED
	texture_mode = LineTextureMode.LINE_TEXTURE_TILE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if path == null or origin == null or target == null: return

	path.curve.set_point_position(0, path.to_local(origin.global_position))
	path.curve.set_point_position(1, path.to_local(target.global_position))

	if origin.name == "right":
		path.curve.set_point_out(0, Vector2(200, 0))
		path.curve.set_point_in(1, Vector2(-200, 0))
	elif origin.name == "top":
		path.curve.set_point_out(0, Vector2(0, 200))
		path.curve.set_point_in(1, Vector2(0, -200))
	elif origin.name == "left":
		path.curve.set_point_out(0, Vector2(-200, 0))
		path.curve.set_point_in(1, Vector2(200, 0))
	elif origin.name == "bottom":
		path.curve.set_point_out(0, Vector2(0, -200))
		path.curve.set_point_in(1, Vector2(0, 200))

	points = path.curve.get_baked_points()
