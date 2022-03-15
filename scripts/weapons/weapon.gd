extends Usable

class_name Weapon


export(int) var damage
export(Resource) var ammo = ammo as Ammo
export(int) var current_ammo
export(PackedScene) var muzzle_flash = preload("res://nodes/muzzle_flash.tscn")
export(AudioStream) var shoot_sound


func use(_character):
#	if _character.is_in_group("player"):
#		GameEvents.emit_signal("change_current_weapon", self, _character)
	pass


func shoot(character) -> void:
	pass


func set_ammo(_ammo: Ammo) -> void:
	ammo = _ammo


func get_ammo() -> Ammo:
	return ammo
