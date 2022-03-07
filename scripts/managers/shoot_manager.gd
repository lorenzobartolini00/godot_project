extends Manager

class_name ShootManager

var shoot_timer: Timer

func _ready():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	
	shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout")


func _can_shoot() -> bool:
	var _current_weapon = character.get_current_weapon()
	if _current_weapon:
		var _ammo: Ammo = character.get_current_weapon().get_ammo()
		if _ammo:
			var _has_ammo: bool = character.get_current_weapon().get_ammo().current_ammo > 0
			var _is_shoot_timer_timeout: bool = character.get_current_weapon().is_shoot_timer_timeout
			var _is_freewalk_state = character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK
			
			return _has_ammo and _is_shoot_timer_timeout and _is_freewalk_state
		return false
	else:
		return false


func shoot() -> void:
	if _can_shoot():
#		print(character.name + " has shot")
		var _current_weapon: Weapon = character.get_current_weapon()
		
		character.ammo_manager.consume_current_ammo()
			
		#Setta can_shoot a false finchè non è passato un tempo pari a shoot_time
		_set_shoot_timer()
		
		character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.SHOOTING
		
		#Orienta la direzione dell'arma verso il punto in cui collide lo shooting_raycast
		_aim()
		
		_current_weapon.shoot(character)


func _aim() -> void:
	var shooting_raycast: RayCast = character.get_shooting_raycast()
	var collider = shooting_raycast.get_collider()
		
	if collider is Shootable:
		character.get_weapon_position().look_at(collider.get_global_transform().origin, Vector3.UP)


func _set_shoot_timer():
	character.get_current_weapon().is_shoot_timer_timeout = false
	shoot_timer.wait_time = character.get_current_weapon().shoot_time
	shoot_timer.start()


func _on_shoot_timer_timeout() ->void:
	var _current_weapon: Weapon = character.get_current_weapon() 
	if _current_weapon:
		character.get_current_weapon().is_shoot_timer_timeout = true
		
		character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.FREEWALK
