@tool
extends NinePatchRect


@export_range(0, 360) var hue := 0.0


func apply():
	self.self_modulate = Color.from_hsv(hue/360, 15.0/100, 34.0/100, 1.0)
	$Wrapper/Container/Button/Control2/NinePatchRect.self_modulate = Color.from_hsv(hue/360, 16.0/100, 28.0/100, 1.0)
	$Wrapper/ProgressBar.tint_progress = Color.from_hsv(hue/360, 16.0/100, 28.0/100, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	apply()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply()
