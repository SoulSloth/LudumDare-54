extends Node2D

@onready var hex_resource: Resource = preload("res://hex.tscn")
@onready var tick_timer: Timer = $TickTimer
@onready var terrain: Node2D = $Terrain
@onready var agents: Node2D = $Agents

var offset_array: Array[Array] = [];

func _ready() -> void:
	tick_timer.connect("timeout", _tick_state)
	for row in terrain.y_hexes:
		offset_array.append([])
		for col in terrain.x_hexes:
			offset_array[row].append(terrain.get_children()[row*terrain.x_hexes + col])
	agents.get_children()[0].global_position = offset_array[0][0].global_position

func _tick_state() -> void:
	for agent in agents.get_children():
		var new_pos = agent.grid_pos+(agent.move_goal - agent.grid_pos).normalized();
		agent.grid_pos = new_pos
		var tween = get_tree().create_tween()
		tween.tween_property(agent, "global_position", offset_array[new_pos.x][new_pos.y].global_position, 0.25)
