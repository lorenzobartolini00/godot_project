extends ProjectileWeapon

class_name RemoteController


func shoot(character):
	var shooting_raycast: RayCast = character.get_shooting_raycast()
	var collider = shooting_raycast.get_collider()
	var character_hit
	
	if collider is Controllable:
		character_hit = collider.get_character()
		
		GameEvents.emit_change_controller(character_hit)
		
		character_hit.set_player_controller(character)
		
