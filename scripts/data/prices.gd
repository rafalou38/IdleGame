class_name Prices

static func node_buy(type: Nodes.NodeType, own_count: int) -> float:
	var x = own_count
	match type:
		Nodes.NodeType.SHOP:
			return 9.0 ** (x ** 1.2 + 1)
		Nodes.NodeType.MINE:
			return 8.0 ** (x ** 1.1 + 1)
			# 8 ^ {x ^ 1.1 + 1}
		Nodes.NodeType.PROCESSOR:
			return 8 * (pow(2.5, x) + 1)
			# 9 ^ {\log(x + 1) ^ 1.8 + 1}
		Nodes.NodeType.REFINERY:
			return Util.factorial(x + 4) ** (9 / 10.0)
		Nodes.NodeType.TETHER:
			return 9.0 ** (x ** 0.4 + 1)
		Nodes.NodeType.LAB:
			return 1 + 9.0 ** (x ** 1.2 + 1)
		Nodes.NodeType.RESEARCH_CENTER:
			return 11.0 + 9.0 ** (x ** 1.2 + 1)
	return 1


static func upgrade_price(type: Upgrades.UpgradeType, node: Nodes.NodeType, level: int):
	if node == Nodes.NodeType.MINE && type == Upgrades.UpgradeType.SPEED:
		return 8 * (pow(3.5, level) + 1)
		# 10 * x ^ {3 + 0.04 * x}
	if node == Nodes.NodeType.PROCESSOR && type == Upgrades.UpgradeType.SPEED:
		return 10 * (pow(3, level) + 1)
		# 10 * x ^ {2 + 0.02 * x}
	if node == Nodes.NodeType.PROCESSOR && type == Upgrades.UpgradeType.VALUE:
		return 7 * (pow(2, level) + 1)
	if node == Nodes.NodeType.REFINERY && type == Upgrades.UpgradeType.SPEED:
		return 10 * (pow(3, level) + 1)
	if node == Nodes.NodeType.REFINERY && type == Upgrades.UpgradeType.VALUE:
		return 10 * (pow(7, level) + 1)
	if type == Upgrades.UpgradeType.RP_MARKET:
		return 100
	return 0


static func test_prices():
	print("Shop")
	var t = ""
	for i in range(10):
		t += Util.number_to_human(Prices.node_buy(Nodes.NodeType.SHOP, i)) + " "
	print(t)

	print("Mine")
	t = ""
	for i in range(10):
		t += Util.number_to_human(Prices.node_buy(Nodes.NodeType.MINE, i)) + " "
	print(t)

	print("Processor")
	t = ""
	for i in range(40):
		t += Util.number_to_human(Prices.node_buy(Nodes.NodeType.PROCESSOR, i)) + " "
	print(t)

	print("Refinery")
	t = ""
	for i in range(25):
		t += Util.number_to_human(Prices.node_buy(Nodes.NodeType.REFINERY, i)) + " "
	print(t)

	print("Tether")
	t = ""
	for i in range(15):
		t += Util.number_to_human(Prices.node_buy(Nodes.NodeType.TETHER, i)) + " "
	print(t)
