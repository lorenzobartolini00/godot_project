extends Area

class_name Shootable

onready var character = get_parent()


func _get_configuration_warning() -> String:
	character = get_parent()
	if not character:
		return "Must be placed as a direct child of a Character Node!"
	else:
		return ""


func _ready():
	GameEvents.connect("hit", self, "_on_hit")


func _on_hit(area_hit: Shootable, weapon: Weapon) -> void:
	if area_hit == self:
		GameEvents.emit_signal("change_current_life", -weapon.damage, false, character)

