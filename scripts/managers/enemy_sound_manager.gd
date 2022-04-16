extends SoundManager

class_name EnemySoundManager

onready var speak_timer: Timer


func _ready():
	setup_speak_timer()
	
	if speak_timer.connect("timeout", self, "_on_speak_timer_timeout") != OK:
		print("failure")


func setup_speak_timer() -> void:
	var speak_time: float = character.get_statistics().speak_time
	
	speak_timer = Util.setup_timer(speak_timer,self, speak_time)


func play_on_ai_stream_player():
	var current_ai_state: int = character.ai_manager.get_current_ai_state()
	var ai_sound_name: String = get_ai_sound_name(current_ai_state)
	
	var ai_sound_list: Dictionary = character.get_statistics().ai_sound_list
	var sound_variants: Array 
	var audio_stream_player: AudioStreamPlayer3D = character.get_ai_audio_stream_player()
		
	if ai_sound_name != "":
		sound_variants = ai_sound_list.get(ai_sound_name)
		Util.play_random_sound_from_list(sound_variants, audio_stream_player, false, false)


func _on_speak_timer_timeout():
	if not character.get_is_current_controller():
		play_on_ai_stream_player()


func get_ai_sound_name(current_ai_state: int) -> String:
	var ai_sound_name: String = ""
	
	match current_ai_state:
		Enums.AIState.START:
			ai_sound_name = "start"
		Enums.AIState.IDLE:
			ai_sound_name = "idle"
		Enums.AIState.AIMING:
			ai_sound_name = "aiming"
		Enums.AIState.TARGET_AQUIRED:
			ai_sound_name = "target_acquired"
		Enums.AIState.DODGING:
			ai_sound_name = "dodging"
		Enums.AIState.HURT:
			ai_sound_name = "hurt"
		Enums.AIState.APPROACHING:
			ai_sound_name = "approaching"
		Enums.AIState.SEARCHING:
			ai_sound_name = "searching"
	
	return ai_sound_name
