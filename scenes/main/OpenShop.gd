extends Button


func _on_pressed():
	if $"../VBoxContainer/Shop".open: return
	
	$"../VBoxContainer/Shop".show_shop()
