extends Manager

class_name ReloadManager

var _reload_timer: Timer

func _ready():
	_reload_timer = Timer.new()
	add_child(_reload_timer)
	_reload_timer.one_shot = true
	
	_reload_timer.connect("timeout", self, "_on_reload_timer_timeout")


func can_reload() -> bool:
	var _is_left_in_stock = true
	var _is_weapon_auto_rechargeable: bool = false
	
	if character.is_in_group("player"):
		_is_left_in_stock = _is_left_in_stock()
		
	if character.get_current_weapon() is Blaster:
		_is_weapon_auto_rechargeable = true
	
	var is_freewalk_state = character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK
	
	return is_freewalk_state and _is_left_in_stock and not _is_weapon_auto_rechargeable


func need_reload():
	var weapon: Weapon = character.get_current_weapon()
	if weapon:
		var current_ammo: int = weapon.current_ammo
		
		return current_ammo == 0


func reload() -> void:
	if can_reload():
		var _current_weapon = character.get_current_weapon()
		if _current_weapon:
			play_reload_sound()
			
			GameEvents.emit_signal("reload", character)
			print(character.name + " is reloading...")
			
			character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.RELOADING
			
			_reload_timer.wait_time = character.get_current_weapon().reload_time
			_reload_timer.start()
	else:
		if character.is_in_group("player"):
			if not _is_left_in_stock():
				GameEvents.emit_signal("warning", "Can't reload")
			 


func _is_left_in_stock() -> bool:
	if character.is_in_group("player"):
		var _weapon: Weapon = character.get_current_weapon()
		var inventory: Inventory = character.get_inventory()
		var _ammo: Ammo
		
		if _weapon:
			_ammo = character.get_current_weapon().get_ammo()
			return inventory.is_item_in_stock(_ammo)
			
		return false
	else:
		return true


func _on_reload_timer_timeout():
	var _current_weapon = character.get_current_weapon()
	if _current_weapon:
		var _ammo: Ammo = character.get_current_weapon().get_ammo()
		
		if _ammo:
			character.ammo_manager.max_ammo(_current_weapon, _ammo)
			
			if character.is_in_group("player"):
				character.ammo_manager.consume_ammo_in_stock(1)
			
		
			character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.FREEWALK
#			print(character.name + " finished reloading")


func play_reload_sound() -> void:
	var sound_list: Dictionary = character.get_current_weapon().get_sound_list()
	var weapon_stream_player: AudioStreamPlayer3D = character.get_weapon_audio_stream_player()
	
	var loop: bool = false
	var cut: bool = true
	Util.play_random_sound_from_name("reload", sound_list, weapon_stream_player, loop, cut)
