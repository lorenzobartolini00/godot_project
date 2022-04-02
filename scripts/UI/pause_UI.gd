extends Tab

func _ready():
	self.visible = false
	
	if GameEvents.connect("pause_game", self, "_on_game_paused") != OK:
		print("failure")
	if GameEvents.connect("resume_game", self, "_on_game_resumed") != OK:
		print("failure")
	
	add_to_stack()


func _on_game_paused():
	if runtime_data.current_gameplay_state == Enums.GamePlayState.PAUSED:
		GameEvents.emit_signal("tab_selected", self)
		
		self.visible = true
		name_label.text = "Game Paused"


func _on_game_resumed():
	self.visible = false
	button_container.set_active(false)
