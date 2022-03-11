extends Tab

func _ready():
	self.visible = false
	
	GameEvents.connect("died", self, "_on_died")


func _on_died(character):
	if character.is_in_group("player"):
		self.visible = true
		
		name_label.text = character.get_statistics().die_text
		
		runtime_data.current_gameplay_state = Enums.GamePlayState.DIED
		GameEvents.emit_signal("pause_game")
		GameEvents.emit_signal("tab_selected", self)
		
#		button_container.set_active(true)
