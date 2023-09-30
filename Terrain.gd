@tool
extends Node2D

@onready var hex_resource : Resource = preload("res://hex.tscn")
@export var x_hexes = 5
@export var y_hexes = 5 
@export var x_diff = 84
@export var y_diff = 100
@export var remake_grid = false: set= _do_remake_grid

var offset_array : Array[Array] = []

func _ready() -> void:
	SignalBus.connect("hex_changed_editor",_save_level)

func _draw_board_x(new_x):
	x_hexes = new_x
	_do_remake_grid()
	
func _draw_board_y(new_y):
	y_hexes = new_y
	_do_remake_grid()

func _do_remake_grid(_p_remake_grid = null):
	print("remaking grid")
	offset_array.clear();
	if(hex_resource != null):
		for child in get_children():
			child.queue_free()
		var offset = false
		for y_hex in range(y_hexes):
			offset_array.append([])
			for x_hex in range(x_hexes):
				var new_hex = hex_resource.instantiate();
				new_hex.coords = Vector2(x_hex,y_hex)
				new_hex.position = Vector2(x_diff*x_hex,y_diff*y_hex)
				if(offset):
					new_hex.position += Vector2(x_diff/2,0)
				new_hex.position += Vector2(200,200)
				add_child(new_hex)
				new_hex.set_owner(get_tree().edited_scene_root)
				offset_array[y_hex].append(new_hex)
			offset = !offset
	print(offset_array)

func _save_level(_hex) -> void:
	var scene = PackedScene.new()
	var scene_root = get_parent()
	_set_owner(scene_root,scene_root)
	scene.pack(scene_root)
	print(ResourceSaver.save(scene,'res://TestSave.tscn'))

func _set_owner(node,root):
	if node != root:
		node.owner = root
	for child in node.get_children():
		_set_owner(child, root)
