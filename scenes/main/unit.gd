class_name Unit
extends PathFollow2D

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

	if self.get_parent():
		self.get_parent().remove_child(self)
	con.path.add_child(self)

func destroy():
	if self.get_parent():
		self.get_parent().remove_child(self)

func _ready():
	$Label.label_settings = $Label.label_settings.duplicate(true)

func _process(delta):
	if active:
		$Label.text = str(value)
		if value < 100:
			$Label.label_settings.font_size = 48
		elif value < 1000:
			$Label.label_settings.font_size = 32
		elif value < 10000:
			$Label.label_settings.font_size = 24
		elif value < 100000:
			$Label.label_settings.font_size = 16

		print(1 + (NodeHandler.speed_up_factor-1) * 4)
		progress = progress + delta * speed * min(4, 1 + (NodeHandler.speed_up_factor-1) * 4)

		if progress_ratio >= 1.0:
			print("Done!")
			current_connection.toNode.receive_unit(self)

			active = false
			if self.get_parent():
				self.get_parent().remove_child(self)
			
			
