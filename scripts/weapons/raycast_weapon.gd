extends DotWeapon

class_name RayCastWeapon


func shoot(character) -> void:
	.shoot(character)
	var shooting_raycast = character.get_shooting_raycast() as RayCast
	
	if shooting_raycast:
		var collided_area = character.get_shooting_raycast().get_collider()
	
		if collided_area:
			if collided_area is Shootable:
				GameEvents.emit_signal("hit", collided_area, self.damage)

