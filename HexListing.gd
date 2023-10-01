extends Control

@export var hex_resource : HexResource
@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var hex_label: RichTextLabel = $HBoxContainer/VBoxContainer/HexLabel
@onready var hex_desc: RichTextLabel = $HBoxContainer/VBoxContainer/HexDesc
@onready var mouse_catch: ColorRect = $MouseCatch
@onready var background: ColorRect = $Background

func _ready() -> void:
	texture_rect.texture = hex_resource.texture
	hex_label.text = "[center][u]%s[/u]" % hex_resource.name
	hex_desc.text = hex_resource.Desc

func _on_mouse_catch_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed == true and event.button_index == 1:
		SignalBus.emit_signal("editor_hex_selected",hex_resource)

func _on_mouse_catch_mouse_entered() -> void:
	background.color = Color(0.141, 0.141, 0.141)

func _on_mouse_catch_mouse_exited() -> void:
	background.color = Color(0.161, 0.161, 0.161)
