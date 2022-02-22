extends Manager

class_name LifeManager


func register_damage(damage: int) ->void:
	var inventory: Inventory
	
	var _remaining_damage: int = damage
	
	var _life: Life = character.get_life() 
	var _current_life: int = character.get_current_life()
	var _max_life: int = _life.max_life
	var _remaining_quantity: int = 0
	
	if character.is_in_group("player"):
		inventory = character.get_inventory()
		_remaining_quantity = inventory.get_item_quantity(_life)
	
	
	while _remaining_damage > 0:
		_current_life -= _remaining_damage
		
		if _current_life > 0:
			break
		else:
			if _remaining_quantity > 0:
				_remaining_damage = abs(_current_life)
				
				inventory.set_item_quantity(_life, _remaining_quantity - 1)
				_current_life = _max_life
			else:
				_remaining_damage = 0
				_current_life = 0
	
	character.set_current_life(_current_life)
	
	print(character.name + " has take damage. Weapon: %s, Life: %s" % [String(character.get_current_weapon().name), String(character.get_current_life())])
		
	GameEvents.emit_signal("life_changed", character.get_life(), character)
		
	if character.get_current_life() <= 0 and character.get_is_alive():
		character.statistics.is_alive = false
		GameEvents.emit_signal("died", character)


func life_recover(_new_life: Life) -> void:
	pass


#func _get_remaining_life_quantity() -> int:
#	if character.is_in_group("player"):
#
#		var _items: Array = character.get_inventory().get_items()
#		var lives_list: Array
#
#		if _items.size() > Enums.ItemTipology.LIFE:
#			lives_list = character.get_inventory().get_items()[Enums.ItemTipology.LIFE]
#
#			if not lives_list.empty():
#				return lives_list[0].quantity
#
#	return 0


#func _set_remaining_life_quantity(_quantity: int) -> void:
#	if character.is_in_group("player"):
#
#		var _items: Array = character.get_inventory().get_items()
#		var lives_list: Array
#
#		if _items.size() > Enums.ItemTipology.LIFE:
#			lives_list = character.get_inventory().get_items()[Enums.ItemTipology.LIFE]
#
#			if not lives_list.empty():
#				lives_list[0].quantity = _quantity
	
