@tool
extends Panel


@export_range(0, 360) var hue := 0.0
@export var icon : Texture2D = null

func apply():
	# TODO: Fix this so that it is unique and not global
	# self.get_theme_stylebox("panel", "Panel").bg_color = Color.from_hsv(hue/360, 15.0/100, 34.0/100, 1.0)
	var box = get_theme_stylebox("panel", "Panel").duplicate();
	box.bg_color = Color.from_hsv(hue/360, 15.0/100, 34.0/100, 1.0)
	self.add_theme_stylebox_override("panel", box)

	$ProgressBar.tint_progress = Color.from_hsv(hue/360, 16.0/100, 28.0/100, 1.0)
	$TextureRect.texture = icon

# Called when the node enters the scene tree for the first time.
func _ready():
	apply()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply()
