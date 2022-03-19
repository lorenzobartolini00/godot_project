extends Manager

class_name SoundManager

onready var speak_timer: Timer

export(int) var max_sound_wait = 20


func _ready():
	speak_timer = Timer.new()
	add_child(speak_timer)
	speak_timer.one_shot = true
	
	speak_timer.connect("timeout", self, "_on_speak_timer_timeout")
	
	start_speak_timer()


func _on_speak_timer_timeout():
	play_contextual_sound()
	start_speak_timer()


func start_speak_timer():
	character.rng.randomize()
	
	var wait_time: int = character.rng.randi() % max_sound_wait
	speak_timer.wait_time = clamp(wait_time, 1 , max_sound_wait)
	speak_timer.start()


func play_contextual_sound():
	var index: int
	
	if character.is_in_group("Enemy"):
		index = character.ai_manager.get_current_ai_state()
	
	var sound_list: Array = character.get_statistics().sound_list
	var sound_variants: Array 
	var sound: AudioStream 
		
	if index < sound_list.size():
		sound_variants = sound_list[index]
			
		if sound_variants.size() > 0:
			sound = get_random_sound(sound_variants)
			if sound:
				Util.play_sound(character.get_audio_stream_player(), sound)


func get_random_sound(sound_list: Array) -> AudioStream:
	if sound_list.size() > 0:
		character.rng.randomize()
		var random_number: int = character.rng.randi_range(0, (sound_list.size() - 1))
		
		return sound_list[random_number]
	else:
		return null
