extends HUD

class_name EnemyHUD

export(NodePath) onready var bot_name_label = get_node(bot_name_label) as Label


func _on_controller_changed(new_character: Character, _old_character: Character):
	._on_controller_changed(new_character, _old_character)
	
	if new_character == character:
		bot_name_label.text = character.get_statistics().display_name
