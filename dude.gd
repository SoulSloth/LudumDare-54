extends Node2D

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
			var new_hex = passable_nodes.pick_random()
			grid_pos = new_hex.coords
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", new_hex.global_position+Vector2(0,75), 0.25)
		STATE.STATE_PATHING:
			var new_pos = path_queue.pop_front()
			grid_pos = new_pos
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", offset_array[new_pos.x][new_pos.y].global_position+Vector2(0,75), 0.25)
			if path_queue == []:
				cur_state = STATE.STATE_MINE
		STATE.STATE_MINE:
			# TODO Play Minning sound effect
			mine_goal.hex_resource = ground_resource
			# Check if final position is reachable
			var possible_goal_path = HexUtils.find_path(grid_pos,objective_pos,offset_array)
			if(!possible_goal_path.is_empty()):
				print("Goal found!")
				cur_state = STATE.STATE_GOAL
				path_queue = possible_goal_path
			else:
				print("goal not found")
				cur_state = STATE.STATE_WANDER
				
		STATE.STATE_GOAL:
			print("going to end")
			if path_queue == []:
				SceneChanger.change_scene("res://game_won.tscn")
			else:
				var new_pos = path_queue.pop_front()
				grid_pos = new_pos
				var tween = get_tree().create_tween()
				tween.tween_property(self, "global_position", offset_array[new_pos.x][new_pos.y].global_position+Vector2(0,75), 0.25)

			
func _new_objective(hex : Node2D) -> void:
	print("New objective")
	if hex.hex_resource.passable:
		print("Not a mineable resource")
		## TODO sfx for no valid path
		return;
		
	var objective_neighbors = HexUtils.get_neighbors(hex.coords, offset_array)
	while !objective_neighbors.is_empty():
		var canidate_objective = objective_neighbors.pop_front()
		var canidate_path = HexUtils.find_path(grid_pos,canidate_objective.coords,offset_array)
		if !canidate_path.is_empty():
			cur_state = STATE.STATE_PATHING
			path_queue = canidate_path
			mine_goal = hex
			print("Pathing")
			return;
			
	## TODO sfx for no valid path
	print("No valid path")
