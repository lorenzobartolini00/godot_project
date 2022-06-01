extends Tab

class_name HUD

export(NodePath) onready var canvas_layer = get_node(canvas_layer) as CanvasLayer
export(NodePath) onready var character = get_node(character) as Character
export(NodePath) onready var hint_label = get_node(hint_label) as Label

func _ready():
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")
	if GameEvents.connect("change_controller", self, "_on_controller_changed") != OK:
		print("failure")
	if GameEvents.connect("show_hint", self, "_on_hint_shown") != OK:
		print("failure")


func _on_controller_changed(new_character: Character, _old_character: Character):
	if new_character == character:
		GameEvents.emit_tab_selected(self)
		
		canvas_layer.visible = true
		
		
	else:
		self.set_focus(false)
		canvas_layer.visible = false


func _on_died(character: Character):
	if character is Player:
		GameEvents.emit_signal("pause_game")
		GameEvents.emit_signal("change_tab_to", "game_over")
		global_runtime_data.current_gameplay_state = Enums.GamePlayState.DIED


func _on_hint_shown(_character: Character, text: String):
	if _character == character:
		if text == "":
			hint_label.visible = false
		else:
			hint_label.visible = true
			
		hint_label.text = text


func get_character() -> Character:
	return character
