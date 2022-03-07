extends Usable

class_name Weapon


export(int) var damage
export(Resource) var ammo = ammo as Ammo


func use(_character):
	if _character.is_in_group("player"):
		GameEvents.emit_signal("change_current_weapon", self, _character)
			
		_character.ammo_manager.max_ammo(self.get_ammo())


func shoot(character) -> void:
	pass


func set_ammo(_ammo: Ammo) -> void:
	ammo = _ammo


func get_ammo() -> Ammo:
	return ammo
