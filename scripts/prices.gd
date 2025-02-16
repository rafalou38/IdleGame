class_name Prices

static func node_buy(type: NodeHandler.NodeType, own_count: int) -> float:
	var x = own_count
	match type:
		NodeHandler.NodeType.SHOP:
			return 9.0 ** (x**1.45 + 1)
		NodeHandler.NodeType.MINE:
			return 9.0 ** (x**1.45 + 1)
		NodeHandler.NodeType.PROCESSOR:
			return 9.0 ** (log(x+1)**1.8 + 1)
		NodeHandler.NodeType.REFINERY:
			return Util.factorial(x + 7)
	
	return 0


static func test_prices():
	print("Shop")
	var t = ""
	for i in range(10):
		t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.SHOP, i)) + " "
	print(t)

	print("Mine")
	t = ""
	for i in range(10):
		t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.MINE, i)) + " "
	print(t)

	print("Processor")
	t = ""
	for i in range(40):
		t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.PROCESSOR, i)) + " "
	print(t)

	print("Refinery")
	t = ""
	for i in range(25):
		t += Util.number_to_human(Prices.node_buy(NodeHandler.NodeType.REFINERY, i)) + " "
	print(t)