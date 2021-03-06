extends Resource
class_name Inventory

export(Array, Array) var _items = Array() setget set_items, get_items


func is_empty() -> bool:
	var is_empty: bool = not (_items.size() > 0)
	return is_empty


func set_items(_new_items: Array):
	_items = _new_items
	pass


func get_items() -> Array:
	return _items


func add_item(character, item: Item, quantity: int):
	var _max_quantity = item.max_quantity if not item.is_unique else 1
	var _is_new: bool = true
	
	var _element_changed: Dictionary
	
	var number_of_pages: int = _items.size() - 1
	
	while item.tipology > number_of_pages:
		var new_page = Array()
		_items.append(new_page)
		number_of_pages += 1
	
	var index_page: int = item.tipology
	var page: Array = _items[index_page]
	
	for i in range(page.size()):
		var inventory_item = page[i]
		
		if inventory_item.item_reference.name != item.name:
			continue
		
		inventory_item.quantity = min(inventory_item.quantity + quantity, _max_quantity)
		
		if inventory_item.status != Enums.ItemStatus.UNLOCKED:
			GameEvents.emit_signal("found_new_item", inventory_item)
			print("Found new item: %s" % inventory_item.item_reference.name)
			inventory_item.status = Enums.ItemStatus.UNLOCKED
		
		_element_changed = inventory_item
		
		_is_new = false
	
	if _is_new:
		var new_item = {
			item_reference = item,
			quantity = min(quantity, _max_quantity),
			status = Enums.ItemStatus.LOCKED
		}
		_element_changed = new_item
		
		page.append(new_item)
	
	
	
	GameEvents.emit_inventory_changed(character, self, _element_changed)


func get_item_quantity(_item: Item) -> int:
	var _item_list: Array
	var _tipology: int = _item.tipology
	
	if _items.size() > _tipology:
		_item_list = _items[_tipology]
		
		if not _item_list.empty():
			for _dictionary_item in _item_list:
				if _dictionary_item.item_reference.name == _item.name:
					return _dictionary_item.quantity
	
	return 0


func set_item_quantity(character, _item: Item, _quantity: int) -> void:
	var _item_list: Array
	var _tipology: int = _item.tipology
	
	if _items.size() > _tipology:
		_item_list = _items[_tipology]
		
		if not _item_list.empty():
			for _dictionary_item in _item_list:
				if _dictionary_item.item_reference.name != _item.name:
					continue
					
				_dictionary_item.quantity = _quantity
				
				if _dictionary_item.status != Enums.ItemStatus.UNLOCKED:
					print("Found new item: %s" % _dictionary_item.item_reference.name)
					_dictionary_item.status = Enums.ItemStatus.UNLOCKED
	
				GameEvents.emit_inventory_changed(character, self, _dictionary_item)


func get_dictionary_item(_item_name: String, _tipology: int) -> Dictionary:
	var _item_list: Array
	
	if _items.size() > _tipology:
		_item_list = _items[_tipology]
		
		if not _item_list.empty():
			for _dictionary_item in _item_list:
				if _dictionary_item.item_reference.name != _item_name:
					continue
					
				return _dictionary_item
	
	return Dictionary()


func get_item(_item_name: String, _tipology: int) -> Item:
	var _dictionary_item = get_dictionary_item(_item_name, _tipology) as Dictionary
	
	if  not _dictionary_item.empty():
		return _dictionary_item.item_reference
	else:
		return null


func get_dictionary_item_list(_tipology: int) -> Array:
	if _tipology < _items.size():
		var _dictionary_item_list: Array = _items[_tipology]
		
		var _unlocked_dictionary_item_list: Array
		for _dictionary_item in _dictionary_item_list:
			if _dictionary_item.status != Enums.ItemStatus.LOCKED:
				_unlocked_dictionary_item_list.append(_dictionary_item)
		
		return _unlocked_dictionary_item_list
	
	return []


func get_item_list(_tipology: int) -> Array:
	if _tipology < _items.size():
		var _dictionary_item_list: Array = _items[_tipology]
		
		var _unlocked_item_list: Array
		for _dictionary_item in _dictionary_item_list:
			if _dictionary_item.status != Enums.ItemStatus.LOCKED:
				_unlocked_item_list.append(_dictionary_item.item_reference)
		
		return _unlocked_item_list
	
	return []


func has_item(_item: Item) -> bool:
	var _dictionary_item = get_dictionary_item(_item.name, _item.tipology) as Dictionary
	
	if  not _dictionary_item.empty():
		return _dictionary_item.status == Enums.ItemStatus.UNLOCKED
	else:
		return false


func is_item_in_stock(_item: Item) -> bool:
	return get_item_quantity(_item) > 0


#Debug function
func show_inventory() -> void:
	var index_page: int = 0
	
	for page in _items:
		match index_page:
			Enums.ItemTipology.WEAPON:
				print("Weapons:")
			Enums.ItemTipology.AMMO:
				print("Ammos:")
			Enums.ItemTipology.LIFE:
				print("Life:")
		
		for item in page:
			print("item: %s, quantity: %s, status: %s" % [item.item_reference.name, String(item.quantity), item.status])
		
		index_page += 1
