extends Area

class_name Shootable

onready var character = get_parent() as Character


func _get_configuration_warning() -> String:
	character = get_parent() as Character
	if not character:
		return "Must be placed as a direct child of a Character Node!"
	else:
		return ""


func _ready():
	GameEvents.connect("hit", self, "_on_hit")


func _on_hit(area_hit: Shootable, weapon: Weapon) -> void:
	if area_hit == self:
		character.life_manager.register_damage(weapon.damage)

