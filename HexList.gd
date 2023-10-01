@tool
extends VBoxContainer
var hex_listing_resource : Resource = preload("res://hex_listing.tscn")
@export var remake_hex_list = false #: set= _do_remake_hex_list

func _remake_hex_list():
	for child in get_children():
		child.queue_free();
		
	var hex_dir = DirAccess.open("res://CustomResources/Hexes/")
	if hex_dir:
		hex_dir.list_dir_begin()
		var file_name = hex_dir.get_next();
		while file_name != "":
			if file_name != "HexResource.gd":
				var new_listing = hex_listing_resource.instantiate()
				add_child(new_listing)
				new_listing.set_owner(get_tree().edited_scene_root)
				new_listing.hex_resource = load("res://CustomResources/Hexes/" + file_name)
			file_name = hex_dir.get_next();

func _do_remake_hex_list(_var) -> void:
	_remake_hex_list()
