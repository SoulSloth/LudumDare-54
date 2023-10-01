extends CanvasLayer
@onready var debug_output: RichTextLabel = $Control/MarginContainer/VBoxContainer/DebugOutput
@onready var q: RichTextLabel = $Control/MarginContainer/VBoxContainer/TextureRect/q
@onready var r: RichTextLabel = $Control/MarginContainer/VBoxContainer/TextureRect/r
@onready var s: RichTextLabel = $Control/MarginContainer/VBoxContainer/TextureRect/s

func _ready() -> void:
	SignalBus.hovered_hex_changed.connect(_update_hex_info)
	if(Flags.editor == false):
		queue_free()
	
func _update_hex_info(hex_resource : Node2D) -> void:
	debug_output.text = "Offset Coords: %s" % str(hex_resource.coords)
	q.text = "q=%d" % HexUtils.oddr_to_axial(hex_resource.coords).x
	r.text = "r=%d" % HexUtils.oddr_to_axial(hex_resource.coords).y
	s.text = "s=%d" % HexUtils.oddr_to_axial(hex_resource.coords).z
	debug_output.text += "\nAxel Coords: %s" % str(HexUtils.oddr_to_axial(hex_resource.coords))
