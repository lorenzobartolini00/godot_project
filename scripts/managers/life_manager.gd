extends Manager

class_name LifeManager


func set_life(_value: int) -> void:
	var inventory: Inventory
	
	var _life: Life = character.get_life() 
	var _current_life: int = character.get_current_life()
	var _max_life: int = _life.max_life
	
	var _life_slot: LifeSlot
	var _max_quantity: int = 0
	var _quantity: int = 0
	
	var _total_life: int = _current_life
	var _max_total_life: int = _max_life
	
	if character.get_is_alive():
		if character.is_in_group("player"):
			inventory = character.get_inventory()
			_life_slot = inventory.get_item("life slot", Enums.ItemTipology.LIFE)
			_quantity = inventory.get_item_quantity(_life)
			_max_quantity = inventory.get_item_quantity(_life_slot)
			
			_total_life = _current_life + _quantity*_max_life
			_max_total_life = (_max_quantity + 1)*_max_life
			
			var _partial_value: int = _total_life + _value
			if _partial_value >= 0 and _partial_value <= _max_total_life:
				_current_life = _partial_value % _max_life
				var _remaining_quantity: int = _partial_value - _current_life
				
				_quantity = 0
				while _remaining_quantity > 0:
					_quantity += 1
					_remaining_quantity -= _max_life
				
				if _current_life == 0 and _quantity > 0:
					_current_life = _max_life
					_quantity -= 1
				
			elif _partial_value < 0:
				_current_life = 0
				_quantity = 0
			elif _partial_value > _max_total_life:
				_current_life = _max_total_life
				_quantity = _max_quantity
			
			inventory.set_item_quantity(_life, _quantity)
		else:
			_current_life = clamp(_current_life + _value, 0, _max_life)
			
		character.set_current_life(_current_life)
		
		GameEvents.emit_signal("life_changed", character.get_life(), character)

		if character.get_current_life() <= 0 and character.get_is_alive():
			character.statistics.is_alive = false
			GameEvents.emit_signal("died", character)
	

func max_life() -> void:
	var _life: Life = character.get_life()
	
	if character.is_in_group("player"):
		var inventory: Inventory = character.get_inventory()
		var _life_slot: LifeSlot = inventory.get_item("life slot", Enums.ItemTipology.LIFE)
	
		var _slot_quantity: int = inventory.get_item_quantity(_life_slot)
	
		inventory.set_item_quantity(_life, _slot_quantity)
	
	character.set_current_life(_life.max_life)
	


