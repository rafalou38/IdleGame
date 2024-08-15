extends PanelContainer

var focused := "home"

func _process(_delta):
	BottomBarButton.focused = focused

func _on_home_button_pressed():
	if focused.to_lower() == "shop":
		$"../Main/Shop".hide_shop()
	if focused.to_lower() == "research":
		$"../Main/Research".hide_research()

	focused = "home"
		
func _on_shop_button_pressed():
	if focused.to_lower() == "research":
		$"../Main/Research".hide_research()

	if focused.to_lower() != "shop":
		$"../Main/Shop".show_shop()
	focused = "shop"

func _on_research_button_pressed() -> void:
	if focused.to_lower() == "shop":
		$"../Main/Shop".hide_shop()
	if focused.to_lower() != "research":
		$"../Main/Research".show_research()


	focused = "research"
	
