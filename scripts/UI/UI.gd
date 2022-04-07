extends Tab

class_name UI


func _ready():
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")
	if GameEvents.connect("pause_game", self, "_on_game_paused") != OK:
		print("failure")


func _on_died(character: Character):
	if character is Player:
		GameEvents.emit_signal("change_tab_to", "game_over")


func _on_game_paused():
	if global_runtime_data.current_gameplay_state == Enums.GamePlayState.PAUSED:
		GameEvents.emit_signal("change_tab_to", "pause")
