extends DotWeapon

class_name RayCastWeapon

export(float) var max_distance

func shoot(shooting_raycast: RayCast) -> void:
	var collided_area = shooting_raycast.get_collider()
	
	if collided_area:
		if collided_area is Shootable:
			GameEvents.emit_signal("hit", collided_area, self)
