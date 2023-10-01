extends Node2D

@onready var hex_resource: Resource = preload("res://hex.tscn")
@onready var tick_timer: Timer = $TickTimer
@onready var terrain: Node2D = $Terrain
@onready var agents: Node2D = $Agents
@onready var agent: Node2D = $Terrain/agent
@onready var instructions: RichTextLabel = $Instructions

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
	
	get_tree().create_timer(5.0).timeout.connect(_slide_out_text)
	var blood_tween = get_tree().create_tween()
	blood_tween.tween_property(instructions, "modulate", Color(1, 0, 0.016), 4.0)

#	# TODO: Remove ad-hoc agent placement
	agent.global_position = offset_array[0][0].global_position+Vector2(0,75)
	
func _tick_state() -> void:
	for node in terrain.get_children():
		if node.is_in_group("agent"):
			pass
			node.tick();

func _slide_out_text() -> void:
	var out_tween = get_tree().create_tween()
	out_tween.tween_property(instructions, "position", Vector2(0,-500),5.0).as_relative().set_trans(Tween.TRANS_BOUNCE)
