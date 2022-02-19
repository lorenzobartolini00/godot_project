extends Item

class_name Weapon


export(int) var damage
export(Resource) var ammo = ammo as Ammo


func set_ammo(_ammo: Ammo) -> void:
	ammo = _ammo


func get_ammo() -> Ammo:
	return ammo
