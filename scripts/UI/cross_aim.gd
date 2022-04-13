extends CenterContainer

export(NodePath) onready var hud = get_node(hud) as HUD
export(Array, Color) var colors
export(NodePath) onready var cross_air_color_rect = get_node(cross_air_color_rect) as ColorRect


func _ready():
	if GameEvents.connect("target_acquired", self, "_on_target_acquired") != OK:
		print("failure")


func _on_target_acquired(_character: Character, target_tipology: int):
	if _character == hud.get_character():
		cross_air_color_rect.color = colors[target_tipology]
