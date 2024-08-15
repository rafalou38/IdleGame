extends PanelContainer


func _process(_delta):
	$Wallet/Label.text = Util.number_to_human(Economy.money)
	$Wallet/Label2.text = " · "+ Util.number_to_human(Economy.var_money()) +"/s"
