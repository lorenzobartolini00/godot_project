extends Node


func list_folder(path: String) -> Array:
	var dir = Directory.new()
	var list: Array = []
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				list.append(String(path + file_name))
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return list


func load_folder(path: String) -> Array:
	var elements: Array = []
	var path_list: Array = list_folder(path)
	
	if not path_list.empty():
		for element_path in path_list:
			var element: Resource = ResourceLoader.load(element_path, "",true)
			if element.is_local_to_scene():
				element.setup_local_to_scene()
			
			elements.append(element)
		
	return elements

