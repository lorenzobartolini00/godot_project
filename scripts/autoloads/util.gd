extends Node

onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()


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

#--Audio section--

#Riproduce suono sullo stream player fornito e si assicura che non sia impostato su loop
func play_sound(audio_stream_player:AudioStreamPlayer3D, stream: AudioStream, loop: bool, cut: bool) -> void:
	if cut:
		audio_stream_player.stop()
		audio_stream_player.playing = false
	if not audio_stream_player.is_playing():
		if stream:
		
			audio_stream_player.stream = stream
			audio_stream_player.playing = true
		
			if stream is AudioStreamMP3:
				stream.loop = loop
			elif stream is AudioStreamSample:
				match loop:
					true:
						stream.loop_mode = AudioStreamSample.LOOP_FORWARD
					false:
						stream.loop_mode = AudioStreamSample.LOOP_DISABLED


#Estrae dalla lista data un audio causale
func get_random_sound(sound_variants: Array) -> AudioStream:
	if sound_variants.size() > 0:
		rng.randomize()
		var random_number: int = rng.randi_range(0, (sound_variants.size() - 1))
		
		return sound_variants[random_number]
	else:
		return null


#Estrae dal dizionario dato una lista di varianti associata al nome fornito.
#Es: se passo come sound_name "hit", restituisce un array con tutte varianti per il
#suono "hit"
func get_sound_variants(sound_name: String, sound_list: Dictionary) -> Array:
	var sound_variants: Array
	
	if sound_list.has(sound_name):
		sound_variants = sound_list.get(sound_name)
		return sound_variants
	
	return []


#Riproduce un suono casuale dall'elenco fornito
func play_random_sound_from_list(sound_variants: Array, audio_stream_player: AudioStreamPlayer3D, loop: bool, cut: bool):
	var sound: AudioStream 
	
	if sound_variants.size() > 0:
		sound = get_random_sound(sound_variants)
		if sound:
			Util.play_sound(audio_stream_player, sound, loop, cut)


#Riproduce un suono casuale a partire dal nome
#E' un metodo compatto per evitare di chiamare get_sound_variants() e poi
#play_random_sound_from_list().
func play_random_sound_from_name(sound_name: String, sound_list: Dictionary, audio_stream_player: AudioStreamPlayer3D, loop: bool, cut: bool):
	var sound: AudioStream 
	var sound_variants: Array = Util.get_sound_variants(sound_name, sound_list)
	
	if sound_variants.size() > 0:
		sound = get_random_sound(sound_variants)
		if sound:
			Util.play_sound(audio_stream_player, sound, loop, cut)




