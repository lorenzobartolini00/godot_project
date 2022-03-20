extends Manager

class_name SoundManager

onready var speak_timer: Timer

export(int) var max_sound_wait = 20


func _ready():
	speak_timer = Timer.new()
	add_child(speak_timer)
	speak_timer.one_shot = true
	
	speak_timer.connect("timeout", self, "_on_speak_timer_timeout")
	GameEvents.connect("hit", self, "_on_hit")
	
	if character.is_in_group("Enemy"):
		start_speak_timer()


func _on_hit(area_hit: Shootable, damage: int) -> void:
	if area_hit == character.damage_area:
		play_on_character_stream_player("hit")


func play_on_character_stream_player(sound_name: String) -> void:
	var sound_list: Dictionary = character.get_statistics().sound_list
	var audio_stream_player: AudioStreamPlayer3D = character.get_audio_stream_player()
	
	Util.play_random_sound_from_name(sound_name, sound_list, audio_stream_player, false, false)


func play_on_ai_stream_player():
	var index: int = character.ai_manager.get_current_ai_state()
	
	var ai_sound_list: Array = character.get_statistics().ai_sound_list
	var sound_variants: Array 
	var audio_stream_player: AudioStreamPlayer3D = character.get_ai_audio_stream_player()
		
	if index < ai_sound_list.size():
		sound_variants = ai_sound_list[index]
		Util.play_random_sound_from_list(sound_variants, audio_stream_player, false, false)


func _on_speak_timer_timeout():
	if character.is_in_group("Enemy"):
		play_on_ai_stream_player()
		start_speak_timer()


func start_speak_timer():
	character.rng.randomize()
	
	var wait_time: int = character.rng.randi() % max_sound_wait
	speak_timer.wait_time = clamp(wait_time, 1 , max_sound_wait)
	speak_timer.start()


#func reproduce_random_sound(sound_list: Array, audio_stream_player: AudioStreamPlayer3D):
#	var sound: AudioStream 
#
#	if sound_list.size() > 0:
#		sound = get_random_sound(sound_list)
#		if sound:
#			Util.play_sound(audio_stream_player, sound)
#
#
#func get_random_sound(sound_list: Array) -> AudioStream:
#	if sound_list.size() > 0:
#		character.rng.randomize()
#		var random_number: int = character.rng.randi_range(0, (sound_list.size() - 1))
#
#		return sound_list[random_number]
#	else:
#		return null
