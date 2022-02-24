extends Usable

class_name Weapon


export(int) var damage
export(Resource) var ammo = ammo as Ammo


func use(_character):
	#Seleziono la nuova arma raccolta come quella corrente
	GameEvents.emit_signal("change_current_weapon", self, _character)


func set_ammo(_ammo: Ammo) -> void:
	ammo = _ammo


func get_ammo() -> Ammo:
	return ammo
