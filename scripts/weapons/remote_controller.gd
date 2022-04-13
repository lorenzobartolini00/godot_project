extends ProjectileWeapon

class_name RemoteController


func shoot(character):
	var shooting_raycast: RayCast = character.get_shooting_raycast()
	var collider = shooting_raycast.get_collider()
	
	if collider is Controllable:
		GameEvents.emit_signal("change_controller", collider.get_character())
