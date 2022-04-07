extends Node

export(Resource)var global_runtime_data = global_runtime_data as RuntimeData


func _ready():
	if GameEvents.connect("pause_game", self, "_on_game_paused") != OK:
		print("failure")
	if GameEvents.connect("resume_game", self, "_on_game_resumed") != OK:
		print("failure")
	if GameEvents.connect("back", self, "_on_back") != OK:
		print("failure")
	
	GameEvents.emit_signal("resume_game")


func _input(_event):
	if Input.is_action_just_pressed("pause") \
	and global_runtime_data.current_gameplay_state != Enums.GamePlayState.IN_DIALOG \
	and global_runtime_data.current_gameplay_state != Enums.GamePlayState.DIED\
	and is_scene_pausable():
		toggle_pause()


func toggle_pause() -> void:
		if get_tree().paused == true:
			GameEvents.emit_signal("resume_game")
			TabManager.clear_tab_stack_to_root()
		else:
			global_runtime_data.current_gameplay_state = Enums.GamePlayState.PAUSED
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			GameEvents.emit_signal("pause_game")
			GameEvents.emit_signal("change_tab_to", "pause")


func _on_back():
	if TabManager.is_current_tab_root()\
	and is_scene_pausable()\
	and get_tree().paused == true:
		toggle_pause()


func _on_game_paused() -> void:
	if is_scene_pausable():
		get_tree().paused = true


func _on_game_resumed() -> void:
	if is_scene_pausable():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY
	
	get_tree().paused = false


func is_scene_pausable() -> bool:
	return get_parent() is Level
