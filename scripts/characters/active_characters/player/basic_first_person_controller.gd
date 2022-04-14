extends ActiveCharacter

class_name BasicFirstPersonController

export(NodePath) onready var input_manager = get_node(input_manager) as InputManager
export(NodePath) onready var camera = get_node(camera) as Camera
export(NodePath) onready var camera_pivot = get_node(camera_pivot) as Spatial
export(bool) onready var is_active

export var _mouse_sensitivity := 0.1
export var _joy_sensitivity := 1.3

var is_current_controller: bool = false
var is_jumping: bool = false


func _ready():
	if GameEvents.connect("change_controller", self, "_on_controller_changed") != OK:
		print("failure")
	
	GameEvents.emit_signal("change_current_life", 0, true, self)
	GameEvents.emit_signal("change_current_weapon", get_current_weapon(), self)


func _on_controller_changed(new_controller, _old_controller) -> void:
	if new_controller == self:
		is_current_controller = true
		camera.current = true
		
		self.add_to_group("resistance")
	else:
		is_current_controller = false
		camera.current = false
			
		if self.is_in_group("resistance"):
			self.remove_from_group("resistance")


func _physics_process(delta):
	if get_is_alive():
		set_is_jumping(false)
		
		if is_current_controller:
			player_behaviour(delta)
		else:
			bot_behaviour(delta)


#Definisce la logica da utilizzare quando il character 
#viene controllato dal giocatore
func player_behaviour(delta):
	if Input.is_action_pressed("shoot"):
		shoot_manager.shoot(delta)
	elif Input.is_action_just_pressed("reload"):
		reload_manager.reload()
	if Input.is_action_just_pressed("jump"):
		jump(delta)
		
		GameEvents.emit_signal("stop_sliding", self)
	
	check_target()
	
	movement(delta)
	joy_aim()


#Definisce la logica da utilizzare quando il character 
#è un bot
func bot_behaviour(delta):
	pass


func movement(delta) -> void:
	var input_direction: Vector2 = input_manager.get_input_movement_direction()
	
	var direction_vector: Vector3 = Vector3()
	var new_velocity: Vector3 = Vector3()
	
	var move_speed: float = self.get_statistics().move_speed
	var ground_acceleration: float = self.get_statistics().ground_acceleration
	var air_acceleration: float = self.get_statistics().air_acceleration
	
	var current_acceleration: float
	
	if is_on_floor():
		current_acceleration = ground_acceleration
	else:
		current_acceleration = air_acceleration
		
	# Floor normal.
	var floor_normal: Vector3 = floor_raycast.get_collision_normal()
	if floor_normal.length_squared() < 0.001:
		# Set normal to Y+ if on air.
		floor_normal = Vector3(0, 1, 0)
		
	direction_vector += input_direction.y*transform.basis.z
	direction_vector += input_direction.x*transform.basis.x
				
	# Calculate the velocity.
	new_velocity = direction_vector.slide(floor_normal).normalized() * move_speed
	
	set_velocity(new_velocity, current_acceleration, delta)


func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		var jump_speed: float = self.get_statistics().jump_speed
		var new_velocity: Vector3 = Vector3(0, jump_speed, 0)
		
		set_instant_velocity(new_velocity)
		
		set_is_jumping(true)
		


func _input(event) -> void:
	if is_current_controller:
		if self.get_is_alive():
			aim(event)
		
	else:
		pass


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
	
		var current_camera_rotation = camera_pivot.rotation_degrees.x
		current_camera_rotation -= y_motion
		camera_pivot.rotation_degrees.x = clamp(current_camera_rotation, -90, 90)


func joy_aim():
	var x_axis: float = Input.get_axis("aim_left", "aim_right")
	var y_axis: float = Input.get_axis("aim_down", "aim_up")
	
	#Rotazione attorno all'asse Y
	rotation_degrees.y -= _joy_sensitivity*x_axis
		
	#Rotazione Camera attorno all'asse X
	
	var current_camera_rotation = camera_pivot.rotation_degrees.x
	current_camera_rotation += _joy_sensitivity*y_axis
	camera_pivot.rotation_degrees.x = clamp(current_camera_rotation, -90, 90)


func get_is_active() -> bool:
	return is_active


func set_is_active(_is_active: bool):
	is_active = _is_active


func get_is_jumping() -> bool:
	return is_jumping


func set_is_jumping(_is_jumping) -> void:
	is_jumping = _is_jumping


func get_is_current_controller() -> bool:
	return is_current_controller


func set_is_current_controller(_is_current_controller) -> void:
	is_current_controller = _is_current_controller


