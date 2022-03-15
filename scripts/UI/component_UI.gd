tool
extends Node

class_name UIComponent

onready var ui: UI = get_parent()

#var _current_weapon: Weapon
#var _ammo: Ammo

func _get_configuration_warning() -> String:
	ui = get_parent() as UI
	if not ui:
		return "Must be placed as a direct child of a Character Node!"
	else:
		return ""

