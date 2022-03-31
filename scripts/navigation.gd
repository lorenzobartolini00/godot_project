extends Navigation

export var step_default: float = 0.95

func navigate(character: Character, path: PoolVector3Array, delta) -> PoolVector3Array:
	var direction = Vector3()
	var velocity: Vector3 = character.velocity
	var speed: float = character.get_statistics().move_speed
	var accel: float = character.get_statistics().pathfinding_accel

	if path.size() > 0:
		var step_size = step_default / clamp(character.velocity.length(), 0.1, 1)
		
		var destination: Vector3 = path[0]
		destination.y = character.translation.y
		
		direction = destination - character.translation
		
#		print("v: " + str(character.velocity.length()))
#		print("l: " + str(length))
#		print("s: " + str(step_size))
		
		if direction.length() < step_size:
			path.remove(0)
		
		character.set_velocity(direction.normalized() * speed, accel, delta)
		
#		velocity = velocity.linear_interpolate(direction.normalized() * speed, delta * 10)
#		character.velocity = character.move_and_slide(velocity, Vector3.UP)
		
		direction.y = 0
		if direction:
			var look_at_point = character.translation + direction.normalized()
			var turning_speed: float = character.get_statistics().turning_speed
			
			character.transform = character.smooth_look_at(character, look_at_point, turning_speed, delta)
			
			if character.get_runtime_data().current_ai_state == Enums.AIState.SEARCHING:
				var upper_part: Spatial = character.get_upper_part()
				
				upper_part.set_as_toplevel(true)
				upper_part.transform = character.smooth_look_at(upper_part, Vector3(look_at_point.x, upper_part.transform.origin.y, look_at_point.z), turning_speed, delta)
				upper_part.set_as_toplevel(false)
			
	return path


func get_points(character: Enemy, target_position: Vector3) -> PoolVector3Array:
	return  get_simple_path(character.translation, get_closest_point(target_position))
