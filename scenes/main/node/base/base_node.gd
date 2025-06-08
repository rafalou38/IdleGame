class_name GameNode
extends Node2D


class Connection:
	var fromNode: GameNode = null
	var fromKnob: OutKnob = null

	var toNode: GameNode = null
	var toKnob: InKnob = null
	
	var path: Path2D = null

@export var type: Nodes.NodeType = Nodes.NodeType.SHOP

var data: NodeData
var inbound_connections := []

@export var input_knob_count := 0
@export var output_knob_count := 0

@onready var body: RigidBody2D = $rb
@onready var KnobContainer := $rb/Control/Knobs

var spawned := false
@export var spawn_timeout := 0.0

var out_queue: Array[Unit] = []
var input_queue: Array[Unit] = []

var progress := 0.0

var last_knob_positions: Dictionary = {}
var pending_forces := {}



var round_robin_id := 0
func update_units():
	var max_per_frame := 5
	var count := 0
	while out_queue.size() > 0 and data.outbound_connections.size() > 0 and count < max_per_frame:
		var unit: Unit = out_queue.pop_back()
		round_robin_id = (round_robin_id + 1) % data.outbound_connections.size()
		var con: Connection = data.outbound_connections[round_robin_id]
		unit.spawn(con)
		count += 1

func push_unit(unit: Unit):
	out_queue.append(unit)

func receive_unit(unit: Unit):
	if(input_queue.size() <= 10):
		input_queue.append(unit)
	else:
		unit.queue_free()

func _ready():
	$rb/CollisionShape2D.shape = $rb/CollisionShape2D.shape.duplicate()
	# $AnimationPlayer.play("spawn")

var update_timer := 0.0

func _process(delta):
	update_timer += delta
	if update_timer >= 0.1:
		$rb/Control/node_ui.progress = progress
		update_units()
		update_timer = 0.0
		
func _physics_process(_delta):
	for con in pending_forces.keys():
		var f = pending_forces[con]
		con.fromNode.body.apply_force(f.from_force, f.from_pos)
		con.toNode.body.apply_force(f.to_force, f.to_pos)



const EPSILON = 0.1 
func _refresh_line(con: Connection):
	var from_pos = con.fromKnob.global_position
	var to_pos = con.toKnob.global_position

	var last = last_knob_positions.get(con, null)
	if last != null:
		var from_delta = last.from.distance_squared_to(from_pos)
		var to_delta = last.to.distance_squared_to(to_pos)
		if from_delta < EPSILON * EPSILON and to_delta < EPSILON * EPSILON:
			return

	last_knob_positions[con] = { from = from_pos, to = to_pos }

	var pos_0 := con.path.to_local(from_pos + con.fromKnob.pivot_offset)
	var pos_1 := con.path.to_local(to_pos + con.toKnob.pivot_offset)

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

	if pos_0.distance_to(pos_1) > 250:
		var force = (pos_1 - pos_0) * Engine.physics_ticks_per_second / 60
		pending_forces[con] = {
			from_force = force,
			to_force = -force,
			from_pos = con.fromKnob.position,
			to_pos = con.toKnob.position
		}

	else:
		pending_forces.erase(con)

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
