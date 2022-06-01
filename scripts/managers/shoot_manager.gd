extends Manager

class_name ShootManager

var shoot_timer: Timer

func _ready():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	
	if shoot_timer.connect("timeout", self, "_on_shoot_timer_timeout") != OK:
		print("failure")


func can_shoot() -> bool:
	var _current_weapon = character.get_current_weapon()
	if _current_weapon:
		var _ammo: Ammo = character.get_current_weapon().get_ammo()
		if _ammo:
			var _has_ammo: bool = character.get_current_weapon().ammo_in_mag > 0
			var _is_shoot_timer_timeout: bool = is_shoot_timer_timeout()
			var _is_freewalk_state = character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK
			var is_charged: bool = true
			
			if _current_weapon.has_method("is_charged"):
				is_charged = _current_weapon.is_charged()
			
			return _has_ammo and _is_shoot_timer_timeout and _is_freewalk_state and is_charged
		return false
	else:
		return false


func shoot(_delta) -> void:
	if can_shoot():
#		print(character.name + " has shot")
		var _current_weapon: Weapon = character.get_current_weapon()
		
		character.ammo_manager.update_ammo("consume")
			
		#Setta can_shoot a false finchè non è passato un tempo pari a shoot_time
		_set_shoot_timer()
		
#		print(character.name + " has " +str(_current_weapon.ammo_in_mag) + " ammo left")
		
		_play_weapon_sound()
		
		GameEvents.emit_signal("character_shot", character)
		
		character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.SHOOTING
		
		_current_weapon.shoot(character)
	else:
		if character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK:
			if character.reload_manager.can_reload():
				character.reload_manager.reload()
			else:
				_play_empty_weapon_sound()
	

func _set_shoot_timer():
	character.get_current_weapon().is_shoot_timer_timeout = false
	shoot_timer.wait_time = character.get_current_weapon().shoot_time
	shoot_timer.start()


func _on_shoot_timer_timeout() ->void:
	var _current_weapon: Weapon = character.get_current_weapon() 
	if _current_weapon:
		character.get_current_weapon().is_shoot_timer_timeout = true
		character.get_current_weapon().delete_muzzle(character)
		
		character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.FREEWALK


func is_shoot_timer_timeout() -> bool:
	return character.get_current_weapon().is_shoot_timer_timeout


func _play_weapon_sound() -> void:
	var sound_list: Dictionary = character.get_current_weapon().get_sound_list()
	var weapon_stream_player: AudioStreamPlayer3D = character.get_weapon_audio_stream_player()
	
	var loop: bool = false
	var cut: bool = true
	Util.play_random_sound_from_name("shoot", sound_list, weapon_stream_player, loop, cut)


func _play_empty_weapon_sound() -> void:
	var sound_list: Dictionary = character.get_current_weapon().get_sound_list()
	var weapon_stream_player: AudioStreamPlayer3D = character.get_weapon_audio_stream_player()
	
	var loop: bool = false
	var cut: bool = false
	Util.play_random_sound_from_name("empty_shoot", sound_list, weapon_stream_player, loop, cut)
