extends Node

# Emitted when a new hex is selected in the level editor
signal editor_hex_selected(hex_resource : HexResource)
# Emitted when the mouse hovers a hex
# Can be empty
signal hovered_hex_changed(hex : Node2D)
# When a hex is selected in game
signal hex_selected(hex: Node2D)
