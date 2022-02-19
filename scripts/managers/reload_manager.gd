extends Manager

class_name ReloadManager

var _reload_timer: Timer

func _ready():
	_reload_timer = Timer.new()
	add_child(_reload_timer)
	_reload_timer.one_shot = true
	
	_reload_timer.connect("timeout", self, "_on_reload_timer_timeout")


func can_reload() -> bool:
	
	return character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK


func need_reload():
	
	if character.get_current_weapon():
		if character.get_current_weapon().get_ammo():
			return character.get_current_weapon().get_ammo().current_ammo == 0


func reload() -> void:
	var _current_weapon = character.get_current_weapon()
	if _current_weapon:
		character.get_runtime_data().save_current_state()
		GameEvents.emit_signal("reload", character)
		print(character.name + " is reloading...")
		
		character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.RELOADING
		
		_reload_timer.wait_time = character.get_current_weapon().reload_time
		_reload_timer.start()


func _on_reload_timer_timeout():
	var _current_weapon = character.get_current_weapon()
	if _current_weapon:
		var _ammo: Ammo = character.get_current_weapon().get_ammo()
		
		if _ammo:
			_ammo.current_ammo = _ammo.max_ammo
			GameEvents.emit_signal("ammo_changed", _ammo, character)
		
			character.get_runtime_data().load_last_state()
			print(character.name + " finished reloading")
