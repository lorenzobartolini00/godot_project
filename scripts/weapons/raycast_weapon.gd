extends DotWeapon

class_name RayCastWeapon

export(float) var max_distance

func shoot(character) -> void:
	var shooting_raycast = character.get_shooting_raycast() as RayCast
	
	if shooting_raycast:
		var collided_area = character.get_shooting_raycast().get_collider()
	
		if collided_area:
			if collided_area is Shootable:
				GameEvents.emit_signal("hit", collided_area, self)
