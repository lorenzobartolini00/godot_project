extends Manager

class_name AmmoManager


func _ready():
	#Da sostituire quando verrà implementato il salvataggio
	update_ammo("max")


func set_ammo_for_weapon(_weapon: Weapon):
	if character.is_in_group("player"):
		var _weapon_name: String = _weapon.name
		var inventory: Inventory = character.get_inventory()
		
		var _ammo: Ammo = inventory.get_item(_weapon_name + "_ammo", Enums.ItemTipology.AMMO)
		
		character.get_current_weapon().set_ammo(_ammo)
		
		GameEvents.emit_signal("ammo_changed", _weapon, character)


func update_ammo(action: String, _weapon: Weapon = null):
	var _ammo: Ammo = character.get_current_weapon().get_ammo()
	
	if not _weapon:
		_weapon = character.get_current_weapon()
	
	var ammo_in_mag: int = _weapon.ammo_in_mag
	var mag_size: int = _weapon.mag_size
	var ammo_consume: int = _weapon.ammo_consume
	var ammo_recover: int = _weapon.ammo_recover
	
	match action:
		"consume":
			ammo_in_mag = ammo_in_mag - ammo_consume
		"recover":
			ammo_in_mag = ammo_in_mag + ammo_recover
		"reload":
			if character.is_in_group("player"):
				var inventory: Inventory = character.get_inventory()
				var ammo_in_stock: int = inventory.get_item_quantity(_ammo)
			
				var ammo_needed = mag_size - ammo_in_mag 
			
				if ammo_in_stock > ammo_needed:
					ammo_in_mag = mag_size
					ammo_in_stock -= ammo_needed
				else:
					ammo_in_mag += ammo_in_stock
					ammo_in_stock = 0
			
				inventory.set_item_quantity(_ammo, ammo_in_stock)
			else:
				ammo_in_mag = mag_size
		"max":
			ammo_in_mag = mag_size
	
	if ammo_in_mag < 0:
		ammo_in_mag = 0
	elif ammo_in_mag > mag_size:
		ammo_in_mag = mag_size
	
	_weapon.ammo_in_mag = ammo_in_mag
	
	GameEvents.emit_signal("ammo_changed", _weapon, character)
	
	


#func consume_ammo_in_stock(_quantity: int) -> void:
#	if character.is_in_group("player"):
#		var inventory: Inventory = character.get_inventory()
#		var _ammo: Ammo = character.get_current_weapon().get_ammo()
#		var _current_quantity: int = inventory.get_item_quantity(_ammo)
#
#		inventory.set_item_quantity(_ammo, _current_quantity - _quantity)
	
