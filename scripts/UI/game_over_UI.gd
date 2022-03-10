extends Control

export(NodePath) onready var button_container = get_node(button_container) as ButtonContainer
export(NodePath) onready var text_label = get_node(text_label) as Label


func _ready():
	self.visible = false
	
	GameEvents.connect("died", self, "_on_died")


func _on_died(character):
	if character.is_in_group("player"):
		self.visible = true
		
		text_label.text = character.get_statistics().die_text
		
		character.get_runtime_data().current_gameplay_state = Enums.GamePlayState.DIED
		GameEvents.emit_signal("pause_game")
		
		button_container.set_active(true)
