extends Spatial

export(Resource) var _initial_weapon = _initial_weapon as Weapon

func _ready():
	if _initial_weapon:
		GameEvents.emit_signal("collected", _initial_weapon, 1)
