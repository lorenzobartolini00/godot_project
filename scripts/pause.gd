extends Node

export(Resource)var runtime_data = runtime_data as RuntimeData


func _ready():
	runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if GameEvents.connect("pause_game", self, "_on_game_paused") != OK:
		print("failure")
	if GameEvents.connect("resume_game", self, "_on_game_resumed") != OK:
		print("failure")
	
	GameEvents.emit_signal("resume_game")


func _input(_event):
	set_pause()


func set_pause() -> void:
	if Input.is_action_just_pressed("pause") \
	and runtime_data.current_gameplay_state != Enums.GamePlayState.IN_DIALOG \
	and runtime_data.current_gameplay_state != Enums.GamePlayState.DIED \
	and runtime_data.current_gameplay_state != Enums.GamePlayState.OPTIONS:
		if get_tree().paused == true:
			GameEvents.emit_signal("resume_game")
		else:
			runtime_data.current_gameplay_state = Enums.GamePlayState.PAUSED
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GameEvents.emit_signal("pause_game")


func _on_game_paused() -> void:
	get_tree().paused = true




func _on_game_resumed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	get_tree().paused = false
	runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY


