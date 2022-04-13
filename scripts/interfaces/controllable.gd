extends Area

class_name Controllable

export(NodePath) onready var character = get_node(character) as Character


func get_character() -> Character:
	return character
