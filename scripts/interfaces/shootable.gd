extends Area

class_name Shootable

onready var character: Character = get_parent()


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
		var _life: int = character.get_current_life()
		character.set_current_life(_life - weapon.damage)
		
		print(character.name + " has take damage. Life:" + String(character.get_current_life()))
		GameEvents.emit_signal("life_changed", character.get_current_life(), character)
		
		if character.get_current_life() <= 0 and character.get_is_alive():
			character.statistics.is_alive = false
			GameEvents.emit_signal("died", character)

