extends PanelContainer


func _process(_delta):
	$Wallet/Label.text = str(Economy.money)
