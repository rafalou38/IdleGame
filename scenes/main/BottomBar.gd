class_name BottomBar
extends PanelContainer

var focused := "home"

static var ping_research := 0
static var ping_shop := 0
static var ping_home := 0

func _process(_delta):
	BottomBarButton.focused = focused

	if(focused == "shop"):
		ping_shop = 0
	elif(focused == "research"):
		ping_research = 0
	elif(focused == "home"):
		ping_home = 0

	$HBoxContainer/BottomBarButton.ping = ping_research
	$HBoxContainer/BottomBarButton2.ping = ping_home
	$HBoxContainer/BottomBarButton3.ping = ping_shop

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
	
