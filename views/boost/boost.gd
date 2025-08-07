class_name Boost
extends PanelContainer

static var boost_timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	boost_timer = lerpf(boost_timer, 0, 5.0 * delta)
	$wrapper/TextureButton.self_modulate.a = max(0.2, boost_timer)
	$wrapper/TextureButton.self_modulate.r = 1
	$wrapper/TextureButton.self_modulate.g = 0.4
	$wrapper/TextureButton.self_modulate.b = 0.4


func _on_pressed() -> void:
	boost_timer = lerpf(boost_timer, 2, 0.5)

# From 1 to 2
static func get_boost(s: float = 3.0):
	return 1+ boost_timer * s
