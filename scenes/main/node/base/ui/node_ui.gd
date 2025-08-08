@tool

extends Panel


@export_range(0, 360) var hue := 0.0
@export var color: Color = Color.from_hsv(hue / 360, 38.0 / 100, 29.0 / 100, 1.0)
@export var icon: Texture2D = null
@export var displayName := ""
@export var progress := 0.0



func apply():
	if (hue > 0.1):
		color = Color.from_hsv(hue / 360, 38.0 / 100, 29.0 / 100, 1.0)

		# color = Color.from_hsv(hue / 360, 38.0 / 100, 28.0 / 100, 1.0)
	
	var box = get_theme_stylebox("panel", "Panel").duplicate();
	box.bg_color = color
	self.add_theme_stylebox_override("panel", box)

	$ProgressBar.tint_progress = color.darkened(0.2)
	$TextureRect.texture = icon

	$ProgressBar.value = lerpf($ProgressBar.value, progress * 100, 0.8)

func _ready():
	apply()

# todo 
func _process(_delta):
	apply()
