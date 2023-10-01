extends Node2D

var right_front = preload("res://assets/blender/hexes/0004.png")
var right = preload("res://assets/blender/hexes/0006.png")
var left_back = preload("res://assets/blender/hexes/0007.png")

@onready var cant: AudioStreamPlayer = $Cant
@onready var game_won: AudioStreamPlayer = $GameWon
@onready var move: AudioStreamPlayer = $Move
@onready var new_path: AudioStreamPlayer = $NewPath
@onready var wall_break: AudioStreamPlayer = $WallBreak

@onready var sprite: Sprite2D = $Sprite
@onready var ground_resource: Resource = preload("res://CustomResources/Hexes/Ground.tres")
var grid_pos: Vector2 = Vector2(0,0)
enum STATE {STATE_WANDER, STATE_PATHING, STATE_MINE, STATE_GOAL}
var cur_state = STATE.STATE_WANDER
var mine_goal : Node2D;
@onready var offset_array = get_parent().get_parent().offset_array
var path_queue : Array[Vector2];
## TODO: REMOVE hard coded magic numbers
var objective_pos : Vector2 = Vector2(12,10)

func _ready() -> void:
	SignalBus.hex_selected.connect(_new_objective);
	
func tick() -> void:
	match cur_state:
		STATE.STATE_WANDER:
			var passable_nodes = []
			for hex in HexUtils.get_neighbors(grid_pos,offset_array):
				if hex.hex_resource.passable:
					passable_nodes.append(hex)
			move_character(passable_nodes.pick_random().coords)
		STATE.STATE_PATHING:
			move_character(path_queue.pop_front())
			if path_queue == []:
				cur_state = STATE.STATE_MINE
		STATE.STATE_MINE:
			var scale_tween = get_tree().create_tween()
			scale_tween.tween_property(self, "scale:y",0.75, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
			scale_tween.tween_property(self, "scale:y",1.0, 0.25).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
			wall_break.play()
			mine_goal.hex_resource = ground_resource
			mine_goal.find_child("Mine").emitting = true
			# Check if final position is reachable
			var possible_goal_path = HexUtils.find_path(grid_pos,objective_pos,offset_array)
			if(!possible_goal_path.is_empty()):
				cur_state = STATE.STATE_GOAL
				path_queue = possible_goal_path
				game_won.play()
			else:
				cur_state = STATE.STATE_WANDER
				
		STATE.STATE_GOAL:
			if path_queue == []:
				SceneChanger.change_scene("res://game_won.tscn")
			else:
				move_character(path_queue.pop_front())
				
func move_character(new_pos: Vector2) -> void:
	"Moves the character to an offset position"
	var diff = offset_array[new_pos.x][new_pos.y].global_position+Vector2(0,75)-global_position
	if((new_pos.y - grid_pos.y) == 0):
		if(diff.x > 0):
			sprite.texture = right
			sprite.flip_h = false
		else:
			sprite.texture = right
			sprite.flip_h = true
	else:
		if(diff.y > 0):
			if(diff.x > 0):
				sprite.texture = right_front
				sprite.flip_h = false
			else:
				sprite.texture = right_front
				sprite.flip_h = true
		else:
			if(diff.x > 0):
				sprite.texture = left_back
				sprite.flip_h = true
			else:
				sprite.texture = left_back
				sprite.flip_h = false

	grid_pos = new_pos
	move.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", offset_array[new_pos.x][new_pos.y].global_position+Vector2(0,75), 0.50).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)


func _new_objective(hex : Node2D) -> void:
	if hex.hex_resource.passable:
		cant.play()
		return;
		
	var objective_neighbors = HexUtils.get_neighbors(hex.coords, offset_array)
	while !objective_neighbors.is_empty():
		var canidate_objective = objective_neighbors.pop_front()
		var canidate_path = HexUtils.find_path(grid_pos,canidate_objective.coords,offset_array)
		if !canidate_path.is_empty():
			cur_state = STATE.STATE_PATHING
			path_queue = canidate_path
			mine_goal = hex
			new_path.play()
			return;
			
	cant.play()
