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
		
		_already_here = true
	
	if not _already_here:
		var new_item = {
			item_reference = item,
			quantity = min(quantity, _max_quantity)
		}
		print("Found new item: %s" % new_item.item_reference.name)
		GameEvents.emit_signal("found_new_item", new_item.item_reference)
		
		page.append(new_item)
	
	GameEvents.emit_signal("inventory_changed", self)



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
