extends Control

@export var progress := 0.0
#@export var progress : float :
	#get:
		#return _progress
	#set(v):
		#_progress = clamp(v, 0, 1)
		#$Background/Wrapper/ProgressBar.value = _progress

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress+=0.01
	if progress > 1:
		progress = 0
	$Background/Wrapper/ProgressBar.value = progress * 100
