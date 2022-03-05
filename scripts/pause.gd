extends Node

export(Resource)var runtime_data = runtime_data as RuntimeData


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	GameEvents.connect("pause_game", self, "_on_game_paused")
	GameEvents.connect("resume_game", self, "_on_game_resumed")


func _input(_event):
	set_pause()


func set_pause() -> void:
	if Input.is_action_just_pressed("pause") \
	and runtime_data.current_gameplay_state != Enums.GamePlayState.IN_DIALOG:
		if get_tree().paused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			GameEvents.emit_signal("resume_game")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			runtime_data.current_gameplay_state = Enums.GamePlayState.PAUSED
			GameEvents.emit_signal("pause_game")


func _on_game_paused() -> void:
	get_tree().paused = true


func _on_game_resumed() -> void:
	runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY
	get_tree().paused = false



