class_name Prices

static func node_buy(type: NodeData.NodeType, own_count: int) -> float:
	var x = own_count
	match type:
		NodeData.NodeType.SHOP:
			return 9.0 ** (x**1.45 + 1)
		NodeData.NodeType.MINE:
			return 8.0 ** (x**1.35 + 1)
		NodeData.NodeType.PROCESSOR:
			return 9.0 ** (log(x+1)**1.8 + 1)
		NodeData.NodeType.REFINERY:
			return Util.factorial(x + 6) ** (9/10.0)
		NodeData.NodeType.TETHER:
			return 9.0 ** (x**1.4 + 1)
		NodeData.NodeType.LAB:
			return 9.0 ** (x**1.6 + 1)
		NodeData.NodeType.RESEARCH_CENTER:
			return 9.0 ** (x**1.6 + 1)
	return 1


static func test_prices():
	print("Shop")
	var t = ""
	for i in range(10):
		t += Util.number_to_human(Prices.node_buy(NodeData.NodeType.SHOP, i)) + " "
	print(t)

	print("Mine")
	t = ""
	for i in range(10):
		t += Util.number_to_human(Prices.node_buy(NodeData.NodeType.MINE, i)) + " "
	print(t)

	print("Processor")
	t = ""
	for i in range(40):
		t += Util.number_to_human(Prices.node_buy(NodeData.NodeType.PROCESSOR, i)) + " "
	print(t)

	print("Refinery")
	t = ""
	for i in range(25):
		t += Util.number_to_human(Prices.node_buy(NodeData.NodeType.REFINERY, i)) + " "
	print(t)

	print("Tether")
	t = ""
	for i in range(15):
		t += Util.number_to_human(Prices.node_buy(NodeData.NodeType.TETHER, i)) + " "
	print(t)