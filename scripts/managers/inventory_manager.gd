extends Manager

class_name InventoryManager

export(Array, String) var path_list

func _ready():
	var inventory: Inventory = character.get_inventory()
	
	if inventory.is_empty():
		initialize_inventory()
	else:
		#Siccome all'inizio di ogni livello l'inventario non si deve resettare, non posso chiamare la funzione
		#initialize_inventory(), altrimenti aggiungerei all'inventario degli elementi già esistenti.
		scan_for_unlocked_items()
	
	GameEvents.connect("add_item_to_inventory", self, "_on_add_item_to_inventory")


func _on_add_item_to_inventory(_item: Item, _quantity: int):
	var inventory: Inventory = character.get_inventory()
	
	if _item is Stockable:
		if _item.store_when_collected:
			inventory.add_item(_item, _quantity)


func initialize_inventory() -> void:
	var inventory: Inventory = character.get_inventory()
	var resource_list: Array 

	for path in path_list:
		var file_list: Array = Util.list_folder(path)
		resource_list.append_array(file_list)
	
	for resource in resource_list:
		var item: Item = load(resource)
		
		if item is Item:
			var _unlock: bool = false
			inventory.add_item(item, 0)


func scan_for_unlocked_items() -> void:
	#Visto che possono esserci elementi nell'inventario che sono stati aggiungit in scene precedenti,
	# devo rendere noto a tutti, in particolare alla UI, della loro presenza.
	
	#Per fare ciò scorro tutti i suoi elementi e faccio emettere il segnale "inventory_changed", lo stesso che 
	#viene emesso quando gli strumenti vengono raccolti per la prima volta.
	
	var inventory: Inventory = character.get_inventory()
	var index_array: Array
	
	#Al momento gli unici elementi di cui bisogna comunicare la presenza nell'inventario sono le armi e le bombe(non ancora implementate)
	index_array.append(Enums.ItemTipology.WEAPON)
	index_array.append(Enums.ItemTipology.LIFE)
	index_array.append(Enums.ItemTipology.BOMB)
	
	for index in index_array:
		var _dictionary_list: Array = inventory.get_dictionary_item_list(index)
	
		for _dictionary_item in _dictionary_list:
			GameEvents.emit_signal("inventory_changed", inventory, _dictionary_item)
	
	

