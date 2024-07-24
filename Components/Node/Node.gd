class_name GameNode
extends Node2D

class Connection:
	var outputNode : GameNode = null
	var outputKnob : OutKnob = null

	var inputNode : GameNode = null
	var inputKnob : InKnob = null
	
	var line : Line2D = null

@onready var body : RigidBody2D = $rb

var node_type := "basic"
var outbound_connections := []

func _process(_delta):
	refreshLines()

func _refresh_line(con: Connection):
	con.line.points[0] = con.line.to_local(con.outputKnob.global_position + con.outputKnob.pivot_offset)
	con.line.points[1] = con.line.to_local(con.inputKnob.global_position + con.inputKnob.pivot_offset)
	
	con.outputNode.body.apply_force((con.line.points[1] - con.line.points[0]) * 2, con.outputKnob.position)
	con.inputNode.body.apply_force((con.line.points[0] - con.line.points[1]) * 2, con.inputKnob.position)
func refreshLines():
	for con in outbound_connections:
		_refresh_line(con)

func reset_connections():
	for ink in InKnob.in_knobs:
		ink.connected = false
	for outk in OutKnob.out_knobs:
		outk.connected = false

	for con in outbound_connections:
		con.outputKnob.connected = true
		con.inputKnob.connected = true


func dispose_connection(origin: OutKnob, target: InKnob):
	print("Disposing connection ", origin, target)
	for con in outbound_connections:
		if origin != null and con.outputKnob == origin or target != null and con.inputKnob == target:
			con.outputKnob.connected = false
			con.inputKnob.connected = false

			outbound_connections.erase(con)


func connect_to(origin: OutKnob, target: InKnob):
	print("Connecting ", origin, target)
	origin.connected = true
	target.connected = true

	var con = Connection.new()
	con.outputNode = self
	con.outputKnob = origin

	con.inputNode = target.owner
	con.inputKnob = target

	
	con.line = origin.get_node("Line")


	outbound_connections.append(con)