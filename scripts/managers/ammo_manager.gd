extends Manager

class_name AmmoManager


func set_ammo():
	var _weapon_name: String = character.get_current_weapon().name
	var inventory: Inventory = character.get_inventory()
	
	var _ammo: Ammo = inventory.get_item(_weapon_name + "_ammo", Enums.ItemTipology.AMMO)
	
	character.get_current_weapon().set_ammo(_ammo)
	GameEvents.emit_signal("ammo_changed", character.get_current_weapon().get_ammo(), character)


func consume_ammo_in_stock(_quantity: int) -> void:
	var inventory: Inventory = character.get_inventory()
	var _ammo: Ammo = character.get_current_weapon().get_ammo()
	var _current_quantity: int = inventory.get_item_quantity(_ammo)
	
	inventory.set_item_quantity(_ammo, _current_quantity - _quantity)
	
