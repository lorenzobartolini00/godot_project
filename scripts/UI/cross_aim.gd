extends CenterContainer

export(Array, Color) var colors
export(NodePath) onready var cross_air_color_rect = get_node(cross_air_color_rect) as ColorRect


func _ready():
	GameEvents.connect("target_acquired", self, "_on_target_acquired")


func _on_target_acquired(character: Character, target_tipology: int):
	cross_air_color_rect.color = colors[target_tipology]
