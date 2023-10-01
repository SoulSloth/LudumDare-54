extends Node

@onready var current_scene = get_tree().current_scene;

func change_scene(path: String) -> void:
	call_deferred("_deferred_goto_scene",path);

func _deferred_goto_scene(path: String) -> void:
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene;
