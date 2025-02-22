@tool

extends Panel


@export_range(0, 360) var hue := 0.0
@export var color: Color = Color(0,0,0,0)
@export var icon: Texture2D = null
@export var displayName := ""

func apply():
	if (hue > 0.1):
		color = Color.from_hsv(hue / 360, 38.0 / 100, 29.0 / 100, 1.0)

		# color = Color.from_hsv(hue / 360, 38.0 / 100, 28.0 / 100, 1.0)
	
	var box = get_theme_stylebox("panel", "Panel").duplicate();
	box.bg_color = color
	self.add_theme_stylebox_override("panel", box)

	$ProgressBar.tint_progress = color
	$TextureRect.texture = icon

func _ready():
	apply()

func _process(_delta):
	apply()
