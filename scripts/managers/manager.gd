tool
extends Node

class_name Manager

onready var character: Character = get_parent()

var _current_weapon: Weapon
var _ammo: Ammo

func _get_configuration_warning() -> String:
	character = get_parent() as Character
	if not character:
		return "Must be placed as a direct child of a Character Node!"
	else:
		return ""

