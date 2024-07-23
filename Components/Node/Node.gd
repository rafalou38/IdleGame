class_name GameNode
extends Node2D

class Connection:
	var outputNode : GameNode = null
	var outputKnob : OutKnob = null

	var inputNode : GameNode = null
	var inputKnob : InKnob = null
	
	var line : Line2D = null

var node_type := "basic"
var outbound_connections := []

func _process(_delta):
	refreshLines()

func refreshLines():
	for con in outbound_connections:
		con.line.points[0] = con.line.to_local(con.outputKnob.global_position + con.outputKnob.pivot_offset)
		con.line.points[1] = con.line.to_local(con.inputKnob.global_position + con.inputKnob.pivot_offset)

func dispose_connection(origin: OutKnob, target: InKnob):
	for con in outbound_connections:
		if origin!= null and con.outputKnob == origin or target != null and con.inputKnob == target:
			outbound_connections.erase(con)

			con.outputKnob.connected = false
			con.inputKnob.connected = false

func connect_to(origin: OutKnob, target: InKnob):
	origin.connected = true
	target.connected = true

	var con = Connection.new()
	con.outputNode = self
	con.outputKnob = origin

	con.inputNode = target.owner
	con.inputKnob = target

	
	con.line = origin.get_node("Line")


	outbound_connections.append(con)