extends Control

export(NodePath)onready var header_label = get_node(header_label) as Label
export(Array, Resource)onready var message_array
export(Resource)var runtime_data = runtime_data as RuntimeData
export(NodePath) onready var button_container = get_node(button_container) as ButtonContainer

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	self.visible = false
	
	GameEvents.connect("found_new_item", self, "_on_found_new_item")
	GameEvents.connect("resume_game", self, "_on_game_resumed")
	GameEvents.connect("died", self, "_on_died")


func _on_found_new_item(_item: Dictionary):
	var item: Item = _item.item_reference
	
	if not item is Ammo:
		var new_slide: Slide = message_array[Enums.MessageTipology.NEW_ITEM]
		var header_text: String = new_slide.slides[0] % item.display_name
		
		show_splash_message(header_text, item.description)


func _on_died(character) -> void:
	if character.is_in_group("player"):
		self.visible = false


func show_splash_message(_header_text: String, _slides: Slide) -> void:
	header_label.text = _header_text
	GameEvents.emit_signal("dialogue_initiated", _slides)
	
	self.visible = true
	button_container.set_active(true)
	runtime_data.current_gameplay_state = Enums.GamePlayState.IN_DIALOG
	
	pause()


func _on_game_resumed() -> void:
	button_container.set_active(false)
	self.visible = false


func resume() -> void:
	GameEvents.emit_resume_game()


func pause() -> void:
	GameEvents.emit_signal("pause_game")
