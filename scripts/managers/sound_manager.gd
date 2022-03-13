extends Manager

class_name SoundManager


func _ready():
	GameEvents.connect("state_changed", self, "_on_state_changed")


func _on_state_changed(_character, new_state: int):
	if _character == character:
		var sound_list: Array = character.get_statistics().sound_list
		var sound_variants: Array 
		var sound: AudioStream 
		
		if new_state < sound_list.size():
			sound_variants = sound_list[new_state]
			
			if sound_variants.size() > 0:
				sound = get_random_sound(sound_variants)
				if sound:
					character.play_sound(character.get_audio_stream_player(), sound)


func get_random_sound(sound_list: Array) -> AudioStream:
	if sound_list.size() > 0:
		character.rng.randomize()
		var random_number: int = character.rng.randi_range(0, (sound_list.size() - 1))
		
		return sound_list[random_number]
	else:
		return null
