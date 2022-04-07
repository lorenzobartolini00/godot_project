extends ActiveCharacter

class_name BasicFirstPersonController

export var _mouse_sensitivity := 0.1
export var _joy_sensitivity := 1.3
export var _move_speed :float = 5
export var _jump_high: float = 5


func movement(delta) -> void:
	var direction_vector = Vector3()
	var y_movement: float
	
	if Input.is_action_pressed("move_forward"):
		direction_vector -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction_vector += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction_vector -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction_vector += transform.basis.x
	
	y_movement = velocity.y
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		y_movement = _jump_high
	elif not is_on_floor():
		y_movement = lerp(y_movement, y_movement + _gravity, delta * _vertical_acceleration)
		y_movement = clamp(y_movement, -MAX_TERMINAL_VELOCITY, MAX_TERMINAL_VELOCITY)
	else:
		y_movement = -0.1
	
	velocity.y = 0
	
	var current_acceleration: float
	if is_on_floor():
		current_acceleration = _acceleration
	else:
		current_acceleration = _air_acceleration
	
	velocity = lerp(velocity, direction_vector.normalized() * _move_speed, delta * current_acceleration)
	velocity.y = y_movement
	
	velocity = move_and_slide(velocity, Vector3.UP, true)


func aim(event: InputEvent) -> void:
	var x_motion: float
	var y_motion: float
	
	#Se mouse_motion non è del tipo InputEventMouse sarà null. Una sorta di instance_of
	if event is InputEventMouseMotion:
		#Rotazione attorno all'asse Y
		x_motion = _mouse_sensitivity*event.relative.x
		
		#Rotazione Camera attorno all'asse X
		y_motion = _mouse_sensitivity*event.relative.y
		
		rotation_degrees.y -= x_motion
	
		var current_camera_rotation = $Camera.rotation_degrees.x
		current_camera_rotation -= y_motion
		$Camera.rotation_degrees.x = clamp(current_camera_rotation, -90, 90)


func joy_aim():
	var x_axis: float = Input.get_axis("aim_left", "aim_right")
	var y_axis: float = Input.get_axis("aim_down", "aim_up")
	
	#Rotazione attorno all'asse Y
	rotation_degrees.y -= _joy_sensitivity*x_axis
		
	#Rotazione Camera attorno all'asse X
	
	var current_camera_rotation = $Camera.rotation_degrees.x
	current_camera_rotation += _joy_sensitivity*y_axis
	$Camera.rotation_degrees.x = clamp(current_camera_rotation, -90, 90)



