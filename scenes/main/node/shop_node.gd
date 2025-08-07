extends Node2D

@onready var node : GameNode = $BaseNode

var rp_m := 0
func _process(_delta):
	if $BaseNode.data.upgrades.has(Upgrades.UpgradeType.RP_MARKET):
		rp_m = $BaseNode.data.upgrades[Upgrades.UpgradeType.RP_MARKET]

	if node.input_queue.size() > 0:
		var unit = node.input_queue.pop_front()
		unit.destroy()

		if(unit.type == Unit.UnitType.UNIT || (unit.type == Unit.UnitType.RESEARCH_POINT && rp_m > 0)):
			Economy.money += unit.value

		unit.queue_free()
