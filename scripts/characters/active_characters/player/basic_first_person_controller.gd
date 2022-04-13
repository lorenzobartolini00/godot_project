extends ActiveCharacter

class_name BasicFirstPersonController

export var _mouse_sensitivity := 0.1
export var _joy_sensitivity := 1.3


func movement(delta) -> void:
	var direction_vector: Vector3 = Vector3()
	var new_velocity: Vector3 = Vector3()
	
	var move_speed: float = self.get_statistics().move_speed
	var ground_acceleration: float = self.get_statistics().ground_acceleration
	var air_acceleration: float = self.get_statistics().air_acceleration
	
	if self.get_is_alive():
		if Input.is_action_pressed("move_forward"):
			direction_vector -= transform.basis.z
		elif Input.is_action_pressed("move_backward"):
			direction_vector += transform.basis.z
		if Input.is_action_pressed("move_left"):
			direction_vector -= transform.basis.x
		elif Input.is_action_pressed("move_right"):
			direction_vector += transform.basis.x
	
	var current_acceleration: float
	
	if is_on_floor():
		current_acceleration = ground_acceleration
	else:
		current_acceleration = air_acceleration
	
	new_velocity = direction_vector.normalized() * move_speed
	
	set_velocity(new_velocity, current_acceleration, delta)


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



