extends CanvasLayer
@onready var debug_output: RichTextLabel = $Control/MarginContainer/VBoxContainer/DebugOutput
@onready var q: RichTextLabel = $Control/MarginContainer/VBoxContainer/TextureRect/q
@onready var r: RichTextLabel = $Control/MarginContainer/VBoxContainer/TextureRect/r
@onready var s: RichTextLabel = $Control/MarginContainer/VBoxContainer/TextureRect/s


func _ready() -> void:
	SignalBus.hex_selected.connect(_update_hex_info)
	
func _update_hex_info(hex) -> void:
	debug_output.text = "Offset Coords: %s" % str(hex.coords)
	q.text = "q=%d" % HexUtils.oddr_to_axial(hex.coords).x
	r.text = "r=%d" % HexUtils.oddr_to_axial(hex.coords).y
	s.text = "s=%d" % HexUtils.oddr_to_axial(hex.coords).z
	debug_output.text += "\nAxel Coords: %s" % str(HexUtils.oddr_to_axial(hex.coords))
