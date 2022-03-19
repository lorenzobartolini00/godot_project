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


func play_sound(audio_stream_player:AudioStreamPlayer3D, stream: AudioStream) -> void:
	if not audio_stream_player.is_playing():
		audio_stream_player.stream = stream
		audio_stream_player.playing = true
		
		if stream is AudioStreamMP3:
			stream.loop = false
		elif stream is AudioStreamSample:
			stream.loop_mode = AudioStreamSample.LOOP_DISABLED


func set_node_despawnable(node: Node, despawn_time: int, start: bool) -> void:
	node.set_script(load("res://scripts/despawner.gd"))
	node.set_up_timer()
	
	if despawn_time > 0:
		node.set_despawn_time(despawn_time)
	
	if start:
		node.start_despawn_timer()


func add_node_to_scene(node: Node, position: Vector3) -> void:
	get_tree().get_root().add_child(node)
	
	node.translation = position
