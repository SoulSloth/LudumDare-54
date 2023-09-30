extends Node2D
@export var set_frame: int = 0
@export var sprites : Array[Resource];
@export var sprite_index: int = 0;
@onready var polygon_2d: Polygon2D = $Selection/Polygon2D
@onready var sprite: Sprite2D = $Sprite

@export var coords : Vector2;

var pressed: bool = false

func _ready() -> void:
	sprite.texture = sprites[sprite_index]
	
func _on_selection_mouse_entered() -> void:
	polygon_2d.visible = true;
	SignalBus.emit_signal("hex_selected",self)

func _on_selection_mouse_exited() -> void:
	polygon_2d.visible = false

func color_polygon():
	polygon_2d.color = Color.REBECCA_PURPLE

func _on_selection_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseMotion and event.button_mask == 1 and !pressed:
		sprite_index = (sprite_index+1) % sprites.size()
		sprite.texture = sprites[sprite_index]
		pressed = true;
		SignalBus.emit_signal("hex_changed_editor",self)
