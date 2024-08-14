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