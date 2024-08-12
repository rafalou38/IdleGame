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

func _process(delta):
	if active:
		progress = progress + delta * speed

		if progress_ratio >= 1.0:
			print("Done!")
			current_connection.toNode.receive_unit(self)

			active = false
			if self.get_parent():
				self.get_parent().remove_child(self)
			
			
