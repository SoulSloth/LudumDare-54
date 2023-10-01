extends Node2D

@export var coords : Vector2;
@export var hex_resource : HexResource : set= _set_new_hex_type
@onready var polygon_2d: Polygon2D = $Selection/Polygon2D
@onready var sprite: Sprite2D = $Sprite
var pressed: bool = false

func _ready() -> void:
	_set_new_hex_type(hex_resource)
	
func _on_selection_mouse_entered() -> void:
	polygon_2d.visible = true;
	SignalBus.hovered_hex_changed.emit(self)

func _on_selection_mouse_exited() -> void:
	polygon_2d.visible = false

func color_polygon():
	polygon_2d.color = Color.REBECCA_PURPLE
	
func un_color_polygon():
	polygon_2d.color = Color(1, 1, 1, 0.451)


func _on_selection_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		# Debug
		if Flags.editor == true:
				hex_resource = get_parent().selected_hex_resource;
		else:
			var flash_polygon_timer = get_tree().create_timer(0.25)
			flash_polygon_timer.timeout.connect(un_color_polygon)
			color_polygon()
			SignalBus.hex_selected.emit(self)

func _set_new_hex_type(new_hex_resource : HexResource) -> void:
	if(sprite and new_hex_resource):
		sprite.texture = new_hex_resource.texture
	hex_resource = new_hex_resource
