extends PanelContainer

var focused := "home"

func _process(_delta):
	BottomBarButton.focused = focused

func _on_home_button_pressed():
	if focused.to_lower() == "shop":
		$"../Main/Shop".hide_shop()
	focused = "home"
		
func _on_shop_button_pressed():
	if focused.to_lower() != "shop":
		$"../Main/Shop".show_shop()
	focused = "shop"