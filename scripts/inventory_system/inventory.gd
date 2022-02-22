extends Resource
class_name Inventory

export(Array, Array) var _items = Array() setget set_items, get_items


func set_items(_new_items: Array):
	_items = _new_items
	pass


func get_items() -> Array:
	return _items


func add_item(item: Item, quantity: int):
	var _max_quantity = item.max_quantity if not item.is_unique else 1
	var _already_here: bool = false
	
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
		
		_element_changed = inventory_item
		
		_already_here = true
	
	if not _already_here:
		var new_item = {
			item_reference = item,
			quantity = min(quantity, _max_quantity)
		}
		_element_changed = new_item
		
		print("Found new item: %s" % new_item.item_reference.name)
		GameEvents.emit_signal("found_new_item", new_item.item_reference)
		
		page.append(new_item)
	
	GameEvents.emit_inventory_changed(self, _element_changed)


func get_item_quantity(_item: Item) -> int:
	var _items: Array = get_items()
	var _item_list: Array
	var _tipology: int = _item.tipology
	
	if _items.size() > _tipology:
		_item_list = _items[_tipology]
		
		if not _item_list.empty():
			for _dictionary_item in _item_list:
				if _dictionary_item.item_reference.name != _item.name:
					continue
					
				return _dictionary_item.quantity
	
	return 0


func set_item_quantity(_item: Item, _quantity: int) -> void:
	var _items: Array = get_items()
	var _item_list: Array
	var _tipology: int = _item.tipology
	
	if _items.size() > _tipology:
		_item_list = _items[_tipology]
		
		if not _item_list.empty():
			for _dictionary_item in _item_list:
				if _dictionary_item.item_reference.name != _item.name:
					continue
					
				_dictionary_item.quantity = _quantity
	
				GameEvents.emit_inventory_changed(self, _dictionary_item)


func get_item(_item_name: String, _tipology: int) -> Item:
	var _items: Array = get_items()
	var _item_list: Array
	
	if _items.size() > _tipology:
		_item_list = _items[_tipology]
		
		if not _item_list.empty():
			for _dictionary_item in _item_list:
				if _dictionary_item.item_reference.name != _item_name:
					continue
					
				return _dictionary_item.item_reference
	
	return null


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
		
		for item in page:
			print("item: %s, quantity: %s" % [item.item_reference.name, String(item.quantity)])
		
		index_page += 1
