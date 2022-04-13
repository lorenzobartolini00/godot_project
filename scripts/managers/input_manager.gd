extends Manager

class_name InputManager


func get_input_movement_direction() -> Vector2:
	var direction_vector: Vector2 = Vector2()
	
	if character.is_current_controller:
		direction_vector.y = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
		direction_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	return direction_vector



