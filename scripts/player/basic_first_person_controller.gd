extends Character

class_name BasicFirstPersonController

export var _mouse_sensitivity := 0.1
export var _move_speed :float = 5
export var _jump_high: float = 5
export var _gravity: float = -2.5
export var _acceleration: float = 10.0
export var _air_acceleration: float = 2.0
export var _vertical_acceleration: float = 5

const MAX_TERMINAL_VELOCITY: float = 50.0


var movement_vector: Vector3 


func movement(delta) -> void:
	var direction_vector: Vector3
	var y_movement: float
	
	if Input.is_action_pressed("move_forward"):
		direction_vector -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction_vector += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction_vector -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction_vector += transform.basis.x
	
	y_movement = movement_vector.y
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		y_movement = _jump_high
	elif not is_on_floor():
		y_movement = lerp(y_movement, y_movement + _gravity, delta * _vertical_acceleration)
		y_movement = clamp(y_movement, -MAX_TERMINAL_VELOCITY, MAX_TERMINAL_VELOCITY)
	else:
		y_movement = -0.1
	
	movement_vector.y = 0
	
	var current_acceleration: float
	if is_on_floor():
		current_acceleration = _acceleration
	else:
		current_acceleration = _air_acceleration
	
	movement_vector = lerp(movement_vector, direction_vector.normalized() * _move_speed, delta * current_acceleration)
	movement_vector.y = y_movement
	
	movement_vector = move_and_slide(movement_vector, Vector3.UP)


func aim(event: InputEvent) -> void:
	#Se mouse_motion non è del tipo InputEventMouse sarà null. Una sorta di instance_of
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		#Rotazione attorno all'asse Y
		rotation_degrees.y -= _mouse_sensitivity*mouse_motion.relative.x
		
		#Rotazione Camera attorno all'asse X
		var current_camera_rotation = $Camera.rotation_degrees.x
		current_camera_rotation -= _mouse_sensitivity*mouse_motion.relative.y
		$Camera.rotation_degrees.x = clamp(current_camera_rotation, -90, 90)



