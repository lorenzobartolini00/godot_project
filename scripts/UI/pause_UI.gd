extends Control


export(NodePath) onready var button_container = get_node(button_container) as ButtonContainer
export(NodePath) onready var text_label = get_node(text_label) as Label
export(Resource)var runtime_data = runtime_data as RuntimeData


func _ready():
	self.visible = false
	
	GameEvents.connect("pause_game", self, "_on_game_paused")
	GameEvents.connect("resume_game", self, "_on_game_resumed")


func _on_game_paused():
	if runtime_data.current_gameplay_state == Enums.GamePlayState.PAUSED:
		self.visible = true
		text_label.text = "Game Paused"
			
		button_container.set_active(true)


func _on_game_resumed():
	self.visible = false
	button_container.set_active(false)
