extends CenterContainer

export(NodePath) onready var hud = get_node(hud) as HUD
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(Array, Color) var colors
export(NodePath) onready var cross_air_color_rect = get_node(cross_air_color_rect) as TextureRect


func _ready():
	if GameEvents.connect("target_acquired", self, "_on_target_acquired") != OK:
		print("failure")


func _on_target_acquired(_character: Character, target_tipology: int):
	if _character == hud.get_character():
		cross_air_color_rect.modulate = colors[target_tipology]
	
	match target_tipology:
		Enums.TargetTipology.SHOOTABLE:
			animation_player.play("RESET")
		Enums.TargetTipology.NO_TARGET:
			animation_player.play("RESET")
			
		Enums.TargetTipology.CONTROLLABLE:
			if not animation_player.is_playing():
				animation_player.play("cross_air_spin")
