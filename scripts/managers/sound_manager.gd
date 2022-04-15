extends Manager

class_name SoundManager


func play_on_character_stream_player(sound_name: String, loop: bool = false, cut: bool = false) -> void:
	var sound_list: Dictionary = character.get_statistics().sound_list
	var audio_stream_player: AudioStreamPlayer3D = character.get_audio_stream_player()
	
	Util.play_random_sound_from_name(sound_name, sound_list, audio_stream_player, loop, cut)
