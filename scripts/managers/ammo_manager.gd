extends Manager

class_name AmmoManager


func set_ammo_for_weapon(_weapon: Weapon):
	if character.is_in_group("player"):
		
		var _weapon_name: String = _weapon.name
		var inventory: Inventory = character.get_inventory()
		
		var _ammo: Ammo = inventory.get_item(_weapon_name + "_ammo", Enums.ItemTipology.AMMO)
		
		character.get_current_weapon().set_ammo(_ammo)
		
		GameEvents.emit_signal("current_ammo_changed", character.get_current_weapon().get_ammo(), character)


func max_ammo(_ammo: Ammo) -> void:
	_ammo.current_ammo = _ammo.max_ammo
	
	GameEvents.emit_signal("current_ammo_changed", _ammo, character)


func consume_current_ammo() -> void:
	var _ammo: Ammo = character.get_current_weapon().get_ammo()
	_ammo.current_ammo -= _ammo.ammo_per_shot
	
	
	GameEvents.emit_signal("current_ammo_changed", character.get_current_weapon().get_ammo(), character)


func consume_ammo_in_stock(_quantity: int) -> void:
	if character.is_in_group("player"):
		var inventory: Inventory = character.get_inventory()
		var _ammo: Ammo = character.get_current_weapon().get_ammo()
		var _current_quantity: int = inventory.get_item_quantity(_ammo)
		
		inventory.set_item_quantity(_ammo, _current_quantity - _quantity)
	
