extends Manager

class_name InventoryManager

export(Array, String) var path_list

func _ready():
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
		var file_list: Array = list_files_in_directory(path)
		resource_list.append_array(file_list)
	
	for resource in resource_list:
		var item: Item = load(resource)
		
		if item is Item:
			inventory.add_item(item, 0) 


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(path + file)

	dir.list_dir_end()

	return files
