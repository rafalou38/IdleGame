class_name GameNode
extends Node2D


class Connection:
	var fromNode: GameNode = null
	var fromKnob: OutKnob = null

	var toNode: GameNode = null
	var toKnob: InKnob = null
	
	var path: Path2D = null

@export var type: NodeData.NodeType = NodeData.NodeType.SHOP

var data: NodeData
var inbound_connections := []

@export var input_knob_count := 0
@export var output_knob_count := 0

@onready var body: RigidBody2D = $rb
@onready var KnobContainer := $rb/Control/Knobs

var spawned := false
@export var spawn_timeout := 0.0

var out_queue: Array[Unit] = []
@export var input_queue: Array[Unit] = []

@export var progress := 0.0


var round_robin_id := 0
func update_units():
	if (out_queue.size() > 0 and data.outbound_connections.size() > 0):
		var unit: Unit = out_queue.pop_front()
		round_robin_id = (round_robin_id + 1) % data.outbound_connections.size()
		var con: Connection = data.outbound_connections[round_robin_id]
		unit.spawn(con)

func push_unit(unit: Unit):
	out_queue.append(unit)

func receive_unit(unit: Unit):
	input_queue.append(unit)

func _ready():
	$rb/CollisionShape2D.shape = $rb/CollisionShape2D.shape.duplicate()
	# $AnimationPlayer.play("spawn")

func _process(_delta):
	$rb/Control/node_ui.progress = progress
	refreshLines()
	update_units()

func _refresh_line(con: Connection):
	var pos_0 := con.path.to_local(con.fromKnob.global_position + con.fromKnob.pivot_offset)
	var pos_1 := con.path.to_local(con.toKnob.global_position + con.toKnob.pivot_offset)

	con.path.curve.set_point_position(0, pos_0)
	con.path.curve.set_point_position(1, pos_1)

	if con.toKnob.name.ends_with("t"):
		con.path.curve.set_point_in(1, Vector2(0, -100))
	elif con.toKnob.name.ends_with("b"):
		con.path.curve.set_point_in(1, Vector2(0, 100))
	elif con.toKnob.name.ends_with("l"):
		con.path.curve.set_point_in(1, Vector2(-100, 0))
	elif con.toKnob.name.ends_with("r"):
		con.path.curve.set_point_in(1, Vector2(100, 0))


	if pos_0.distance_to(pos_1) > 200:
		con.fromNode.body.apply_force((pos_1 - pos_0) * 1 * Engine.physics_ticks_per_second / 60, con.fromKnob.position)
		con.toNode.body.apply_force((pos_0 - pos_1) * 1 * Engine.physics_ticks_per_second / 60, con.toKnob.position)

func refreshLines():
	_sync_knobs()
	for con in data.outbound_connections:
		_refresh_line(con)

func reset_connections():
	for ink in InKnob.in_knobs:
		ink.connected = false
	for outk in OutKnob.out_knobs:
		outk.connected = false

	for con in data.outbound_connections:
		con.fromKnob.connected = true
		con.toKnob.connected = true


func dispose_connection(origin: OutKnob, target: InKnob):
	for con in data.outbound_connections:
		if origin != null and con.fromKnob == origin or target != null and con.toKnob == target:
			con.fromKnob.connected = false
			con.toKnob.connected = false

			
			data.outbound_connections.erase(con)
			con.toNode.inbound_connections.erase(con)


func connect_to(origin: OutKnob, target: InKnob):
	origin.connected = true
	target.connected = true

	var con: Connection = Connection.new()
	con.fromNode = self
	con.fromKnob = origin

	con.toNode = target.owner
	con.toKnob = target

	
	con.path = origin.get_node("path")


	data.outbound_connections.append(con)
	con.toNode.inbound_connections.append(con)

	# origin.update_in_path(con.path, target)


func _sync_knobs():
	var ins := KnobContainer.find_children("in-knob-*")
	for in_knob in ins:
		if input_knob_count == 0 or (input_knob_count == inbound_connections.size() and !in_knob.connected):
			in_knob.enabled = false
		else:
			in_knob.enabled = true
	
	var outs := KnobContainer.find_children("out-knob-*")
	for out_knob in outs:
		if output_knob_count == 0 or (output_knob_count == data.outbound_connections.size() and !out_knob.connected):
			out_knob.enabled = false
		else:
			out_knob.enabled = true
