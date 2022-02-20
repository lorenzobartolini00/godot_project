extends Spatial

export(Resource) var _initial_weapon = _initial_weapon as Weapon

func _ready():
	if _initial_weapon:
		GameEvents.emit_signal("collected", _initial_weapon, 1)
	
#	var _current_weapon: Weapon = player.get_current_weapon()
#	var _ammo: Ammo = null
#	var _current_life: int = player.get_current_life()
#
#	if _current_weapon:
#		_ammo = player.get_current_weapon().get_ammo()
#
#	GameEvents.emit_signal("weapon_changed", _current_weapon, player)
#	GameEvents.emit_signal("ammo_changed", _ammo, player)
#	GameEvents.emit_signal("life_changed", _current_life, player)
