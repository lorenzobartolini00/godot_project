extends DotWeapon

class_name RayCastWeapon


func shoot(character) -> void:
	var shooting_raycast = character.get_shooting_raycast() as RayCast
	shooting_raycast.cast_to = Vector3(0, 0, -self.max_distance)
	
	if shooting_raycast:
		var collided_area = character.get_shooting_raycast().get_collider()
	
		if collided_area:
			if collided_area is Shootable:
				GameEvents.emit_signal("hit", collided_area, self)
