extends Navigation



func navigate(character: Character, path: PoolVector3Array, delta) -> PoolVector3Array:
	var direction = Vector3()
	var speed: float = character.get_statistics().move_speed

	# We need to scale the movement speed by how much delta has passed,
	# otherwise the motion won't be smooth.
	var step_size: float = delta * speed

	if path.size() > 0:
		# Direction is the difference between where we are now
		# and where we want to go.
		var destination: Vector3 = path[0]
#		destination = Vector3(destination.x, character.translation.y, destination.z)
		direction = destination - character.translation

		# If the next node is closer than we intend to 'step', then
		# take a smaller step. Otherwise we would go past it and
		# potentially go through a wall or over a cliff edge!
		if step_size > direction.length():
			step_size = direction.length()
			# We should also remove this node since we're about to reach it.
			path.remove(0)

		# Move the robot towards the path node, by how far we want to travel.
		# Note: For a KinematicBody, we would instead use move_and_slide
		# so collisions work properly.
		var velocity: Vector3 = character.velocity
		velocity = velocity.linear_interpolate(direction.normalized() * speed, delta * 5)
		
		velocity = character.move_and_slide(velocity, Vector3.UP)

		# Lastly let's make sure we're looking in the direction we're traveling.
		# Clamp y to 0 so the robot only looks left and right, not up/down.
		
		direction.y = 0
		if direction:
			# Direction is relative, so apply it to the robot's location to
			# get a point we can actually look at.
			var look_at_point = character.translation + direction.normalized()
			# Make the robot look at the point.
			var turning_speed: float = character.get_statistics().turning_speed
			
			character.transform = character.smooth_look_at(character, look_at_point, turning_speed, delta)
			
			if character.get_runtime_data().current_ai_state == Enums.AIState.SEARCHING:
				var upper_part: Spatial = character.get_upper_part()
#				var aim_speed: float = character.get_statistics().aim_speed
				
				upper_part.set_as_toplevel(true)
				upper_part.transform = character.smooth_look_at(upper_part, look_at_point, turning_speed, delta)
				upper_part.set_as_toplevel(false)
			
	return path


func get_points(character: Enemy, target_position: Vector3) -> PoolVector3Array:
	return get_simple_path(character.translation, get_closest_point(target_position))
