class_name GameNode
extends Node2D

class Connection:
	var fromNode: GameNode = null
	var fromKnob: OutKnob = null

	var toNode: GameNode = null
	var toKnob: InKnob = null
	
	var path: Path2D = null


@export var type: NodeHandler.NodeType = NodeHandler.NodeType.SHOP
@onready var body: RigidBody2D = $rb

var node_type := "basic"
var outbound_connections := []
var inbound_connections := []

@export var input_knob_count := 0
@export var output_knob_count := 0
@onready var KnobContainer := $rb/Control/Knobs


func _process(_delta):
	refreshLines()

func _refresh_line(con: Connection):
	var pos_0 := con.path.to_local(con.fromKnob.global_position + con.fromKnob.pivot_offset)
	var pos_1 := con.path.to_local(con.toKnob.global_position + con.toKnob.pivot_offset)

	con.path.curve.set_point_position(0, pos_0)
	con.path.curve.set_point_position(1, pos_1)


	con.fromNode.body.apply_force((pos_1 - pos_0) * 2 * Engine.physics_ticks_per_second / 60, con.fromKnob.position)
	con.toNode.body.apply_force((pos_0 - pos_1) * 2 * Engine.physics_ticks_per_second / 60, con.toKnob.position)

func refreshLines():
	_sync_knobs()
	for con in outbound_connections:
		_refresh_line(con)

func reset_connections():
	for ink in InKnob.in_knobs:
		ink.connected = false
	for outk in OutKnob.out_knobs:
		outk.connected = false

	for con in outbound_connections:
		con.fromKnob.connected = true
		con.toKnob.connected = true


func dispose_connection(origin: OutKnob, target: InKnob):
	print("Disposing connection ", origin, target)
	for con in outbound_connections:
		print(con)
		if origin != null and con.fromKnob == origin or target != null and con.toKnob == target:
			con.fromKnob.connected = false
			con.toKnob.connected = false

			
			outbound_connections.erase(con)
			con.toNode.inbound_connections.erase(con)


func connect_to(origin: OutKnob, target: InKnob):
	print("Connecting ", origin, target)
	origin.connected = true
	target.connected = true

	var con: Connection = Connection.new()
	con.fromNode = self
	con.fromKnob = origin

	con.toNode = target.owner
	con.toKnob = target

	
	con.path = origin.get_node("path")


	outbound_connections.append(con)
	con.toNode.inbound_connections.append(con)


func _sync_knobs():
	var ins := KnobContainer.find_children("in-knob-*")
	for in_knob in ins:
		if input_knob_count == 0 or (input_knob_count == inbound_connections.size() and !in_knob.connected):
			in_knob.enabled = false
		else:
			in_knob.enabled = true
	
	var outs := KnobContainer.find_children("out-knob-*")
	for out_knob in outs:
		if output_knob_count == 0 or (output_knob_count == outbound_connections.size() and !out_knob.connected):
			out_knob.enabled = false
		else:
			out_knob.enabled = true
