extends Manager

class_name ReloadManager

var _reload_timer: Timer

func _ready():
	_reload_timer = Timer.new()
	add_child(_reload_timer)
	_reload_timer.one_shot = true
	
	_reload_timer.connect("timeout", self, "_on_reload_timer_timeout")


func _can_reload() -> bool:
	var _is_left_in_stock = true
	
	if character.is_in_group("player"):
		var inventory: Inventory = character.get_inventory()
		var _ammo: Ammo = character.get_current_weapon().get_ammo()
		_is_left_in_stock = inventory.is_item_in_stock(_ammo)
	
		if not _is_left_in_stock and need_reload():
			GameEvents.emit_signal("warning", "No ammo")
		elif not _is_left_in_stock:
			GameEvents.emit_signal("warning", "No ammo in stock")
			
	var is_freewalk_state = character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK
	
	return is_freewalk_state and _is_left_in_stock


func need_reload():
	var weapon: Weapon = character.get_current_weapon()
	if weapon:
		var current_ammo: int = weapon.current_ammo
		
		return current_ammo == 0


func reload() -> void:
	if _can_reload():
		var _current_weapon = character.get_current_weapon()
		if _current_weapon:
			GameEvents.emit_signal("reload", character)
#			print(character.name + " is reloading...")
			
			character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.RELOADING
			
			_reload_timer.wait_time = character.get_current_weapon().reload_time
			_reload_timer.start()


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
