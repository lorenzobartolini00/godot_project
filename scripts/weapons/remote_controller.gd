extends DotWeapon

class_name RemoteController


func shoot(character):
	.shoot(character)
	
	var shooting_raycast: RayCast = character.get_shooting_raycast()
	var collider = shooting_raycast.get_collider()
	var character_hit
	
	if collider is Controllable:
		character_hit = collider.get_character()
		
		GameEvents.emit_change_controller(character_hit, character)


#Override
func get_target_type(aim_raycast: RayCast) -> int:
	var collider = aim_raycast.get_collider()
	
	if collider:
		if collider is Controllable:
			return Enums.TargetTipology.CONTROLLABLE
		
	return Enums.TargetTipology.NO_TARGET
