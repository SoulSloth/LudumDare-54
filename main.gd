extends Node2D

@onready var hex_resource: Resource = preload("res://hex.tscn")
@onready var tick_timer: Timer = $TickTimer
@onready var terrain: Node2D = $Terrain
@onready var agents: Node2D = $Agents
@onready var agent: Node2D = $Terrain/agent

var offset_array: Array[Array] = [];
var agent_path: Array[Vector2] = [];

func _ready() -> void:
	tick_timer.connect("timeout", _tick_state)
	for x in terrain.x_hexes:
		offset_array.append([])
		for y in terrain.y_hexes:
			offset_array[x].append(0)
	for child in terrain.get_children():
		if not child.is_in_group("agent"):
			offset_array[child.coords.x][child.coords.y] = child

#	# TODO: Remove ad-hoc agent placement
	agent.global_position = offset_array[0][0].global_position+Vector2(0,75)
	
func _tick_state() -> void:
	for node in terrain.get_children():
		if node.is_in_group("agent"):
			pass
			node.tick();
