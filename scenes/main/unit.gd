class_name Unit
extends PathFollow2D

enum UnitType {
	UNIT,
	RESEARCH_POINT
}

var type := UnitType.UNIT
var value := 1.0
var speed := 40.0
var dirty := false

var current_connection: GameNode.Connection = null
var active := false

static var label_settings: Dictionary[int, LabelSettings]
static var label_settings_initialized := false

func spawn(con: GameNode.Connection):
	current_connection = con
	active = true
	dirty = true
	global_position = con.fromKnob.global_position
	progress = 0.0
	loop = false
	call_deferred("_do_spawn", con)

func _do_spawn(con):
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
	con.path.add_child(self)

func destroy():
	var parent = self.get_parent()
	if parent:
		parent.remove_child(self)

func _ready():
	if !label_settings_initialized:
		label_settings_initialized = true
		label_settings = {
			100: $Label.label_settings.duplicate(true),
			1000: $Label.label_settings.duplicate(true),
			10000: $Label.label_settings.duplicate(true),
			100000: $Label.label_settings.duplicate(true)
		}

		label_settings[100].font_size = 32
		label_settings[1000].font_size = 30
		label_settings[10000].font_size = 24
		label_settings[100000].font_size = 16

	$Label.label_settings = label_settings[100]


func sync():
	$Label.text = Util.number_to_human(value)
	var new_settings: LabelSettings
	if value < 100:
		new_settings = label_settings[100]
	elif value < 1000:
		new_settings = label_settings[1000]
	elif value < 10000:
		new_settings = label_settings[10000]
	else:
		new_settings = label_settings[100000]

	if $Label.label_settings != new_settings:
		$Label.label_settings = new_settings

	if type == UnitType.UNIT:
		$Sprite2D.self_modulate = Color.WHITE
		$Label.modulate = Color.BLACK
		
	elif type == UnitType.RESEARCH_POINT:
		$Sprite2D.self_modulate = Color("80c4f6")
		$Label.modulate = Color.WHITE

func _process(delta):
	if active:
		if dirty:
			sync ()
			dirty = false

		progress = progress + delta * speed # * (NodeHandler.speed_up_factor)**2
		# progress = progress + delta * speed * min(4, 1 + (NodeHandler.speed_up_factor-1) * 4)

		if progress_ratio >= 1.0:
			current_connection.toNode.receive_unit(self)

			active = false
			if self.get_parent():
				self.get_parent().remove_child(self)
