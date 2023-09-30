@tool
extends Node2D

@onready var hex_resource : Resource = preload("res://hex.tscn")
@export var x_hexes = 5 : set= _draw_board_x
@export var y_hexes = 5 : set= _draw_board_y
@export var x_diff = 84
@export var y_diff = 100
@export var remake_grid = false: set= _do_remake_grid
var time: float = 0;

func _process(delta: float) -> void:
	var index = 1
	for child in get_children():
		index += 1;
		time += delta
		var y_dis = sin(((time+(index))/5))*10;
		child.position += Vector2(0,sin(time+index*10)*0.5)

func _draw_board_x(new_x):
	x_hexes = new_x
	_do_remake_grid()
	
func _draw_board_y(new_y):
	y_hexes = new_y
	_do_remake_grid()

func _do_remake_grid(_p_remake_grid = null):
	if(hex_resource != null):
		for child in get_children():
			child.queue_free()
		var offset = false
		for y_hex in range(y_hexes):
			for x_hex in range(x_hexes):
				var new_hex = hex_resource.instantiate();
				new_hex.position = Vector2(x_diff*x_hex,y_diff*y_hex)
				if(offset):
					new_hex.position += Vector2(x_diff/2,0)
				new_hex.position += Vector2(200,200)
				add_child(new_hex)
				new_hex.set_owner(get_tree().edited_scene_root)
			offset = !offset
