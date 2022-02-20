extends Manager

class_name AmmoManager


func set_ammo():
	var _ammo_list: Array = _get_ammo_list()
	var _new_ammo: Ammo = null
	
	for _ammo in _ammo_list:
		var _weapon_name: String = character.get_current_weapon().name
		var _ammo_name:String = _ammo.item_reference.name 
		var _suffix:String = "_ammo"
		
		if _weapon_name + _suffix != _ammo_name:
			continue
		
		_new_ammo = _ammo.item_reference
		print("found_ammo. Current_ammo: %s" % _new_ammo.current_ammo)
	
	character.get_current_weapon().set_ammo(_new_ammo)
	
	GameEvents.emit_signal("ammo_changed", character.get_current_weapon().get_ammo(), character)


func is_left_in_stock() -> bool:
	var _ammo_list: Array = _get_ammo_list()
	var _current_weapon: Weapon = character.get_current_weapon()
	
	if _current_weapon:
		var _current_ammo: Ammo = _current_weapon.get_ammo()
		
		if _current_ammo:
		
			for _ammo in _ammo_list:
				if _ammo.item_reference.name != _current_ammo.name:
					continue
				
				if _ammo.quantity > 0:
					return true
	
	return false


func consume_ammo() -> void:
	var _ammo_list: Array = _get_ammo_list()
	var _current_ammo: Ammo = character.get_current_weapon().get_ammo()
	
	for _ammo in _ammo_list:
		if _ammo.item_reference.name != _current_ammo.name:
			continue
		
		_ammo.quantity = max(_ammo.quantity - 1, 0)
		GameEvents.emit_signal("ammo_changed", character.get_current_weapon().get_ammo(), character)


func _get_ammo_list() -> Array:
	var _ammo_list: Array
	
	var player = character
	if player:
		var inventory: Inventory = player.get_inventory()
		
		var _items: Array = inventory.get_items()
		_ammo_list = _items[Enums.ItemTipology.AMMO]
		
	return _ammo_list
