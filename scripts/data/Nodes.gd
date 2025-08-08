extends Node
class_name Nodes


enum NodeType {
	SHOP,
	MINE,
	PROCESSOR,
	REFINERY,
	TETHER,
	DUPLICATOR,
	RESEARCH_CENTER,
	LAB,
	SPEED
}

static var _icons: Dictionary[NodeType, Resource]
static func node_icons(t: NodeType) -> Resource:
	if !_icons.has(t):
		_icons = {
			NodeType.SHOP: preload("res://sprites/icons/sell.svg"),
			NodeType.MINE: preload("res://sprites/icons/mine.svg"),
			NodeType.PROCESSOR: preload("res://sprites/icons/processor.svg"),
			NodeType.REFINERY: preload("res://sprites/icons/refinery.svg"),
			NodeType.TETHER: preload("res://sprites/icons/tether.svg"),
			NodeType.DUPLICATOR: preload("res://sprites/icons/quantum.svg"),
			NodeType.RESEARCH_CENTER: preload("res://sprites/icons/science1.svg"),
			NodeType.LAB: preload("res://sprites/icons/research2.svg"),
			NodeType.SPEED: preload("res://sprites/icons/sp1.svg"),
		}

	return _icons[t]

static func node_color(t: NodeType):
	return {
			NodeType.SHOP: Color("#654a4a"),
			NodeType.MINE: Color("#504a65"),
			NodeType.PROCESSOR: Color("#51654a"),
			NodeType.REFINERY: Color("#8e804f"),
			NodeType.TETHER: Color("#4a6065"),
			NodeType.DUPLICATOR: Color("#00000000"),
			NodeType.RESEARCH_CENTER: Color("#373bb9"),
			NodeType.LAB: Color("#2b88c3"),
			NodeType.SPEED: Color("#92394b"),

		}.get(t, Color("#151515"))