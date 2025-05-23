class_name Unit
extends PathFollow2D

enum UnitType {
	UNIT,
	RESEARCH_POINT
}

@export var type := UnitType.UNIT
@export var value := 1.0
@export var speed := 40.0

var current_connection: GameNode.Connection = null
@export var active := false

func spawn(con: GameNode.Connection):
	current_connection = con
	active = true
	global_position = con.fromKnob.global_position
	progress = 0.0
	loop = false
	var parent = self.get_parent()
	if parent:
		parent.remove_child(self)
	con.path.add_child(self)

func destroy():
	var parent = self.get_parent()
	if parent:
		parent.remove_child(self)

func _ready():
	$Label.label_settings = $Label.label_settings.duplicate(true)

func sync():
	$Label.text = str(value)
	if value < 100:
		$Label.label_settings.font_size = 32
	elif value < 1000:
		$Label.label_settings.font_size = 30
	elif value < 10000:
		$Label.label_settings.font_size = 24
	elif value < 100000:
		$Label.label_settings.font_size = 16

	if type == UnitType.UNIT:
		$Sprite2D.self_modulate = Color.WHITE
		$Label.modulate = Color.BLACK
		
	elif type == UnitType.RESEARCH_POINT:
		$Sprite2D.self_modulate = Color("80c4f6")
		$Label.modulate = Color.WHITE

func _process(delta):
	if active:
		sync()
		progress = progress + delta * speed * (NodeHandler.speed_up_factor)**2
		# progress = progress + delta * speed * min(4, 1 + (NodeHandler.speed_up_factor-1) * 4)

		if progress_ratio >= 1.0:
			current_connection.toNode.receive_unit(self)

			active = false
			if self.get_parent():
				self.get_parent().remove_child(self)

