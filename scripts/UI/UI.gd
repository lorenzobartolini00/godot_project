extends Tab

class_name UI


func _ready():
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")


func _on_died(character: Character):
	if character is Player:
		GameEvents.emit_signal("change_tab_to", "game_over")
		global_runtime_data.current_gameplay_state = Enums.GamePlayState.DIED
