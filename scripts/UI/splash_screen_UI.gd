extends Control

export(NodePath)onready var header_label = get_node(header_label) as Label
export(Array, Resource)onready var message_array
export(Resource)var runtime_data = runtime_data as RuntimeData


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	self.visible = false
	
	GameEvents.connect("found_new_item", self, "_on_found_new_item")
	GameEvents.connect("resume_game", self, "_on_game_resumed")


func _on_found_new_item(_item: Dictionary):
	var item: Item = _item.item_reference
	
	if not item is Ammo:
		var new_slide: Slide = message_array[Enums.MessageTipology.NEW_ITEM]
		var header_text: String = new_slide.slides[0] % item.display_name
		
		show_splash_message(header_text, item.description)


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE and self.visible:
			call_deferred("resume")


func show_splash_message(_header_text: String, _slides: Slide) -> void:
	header_label.text = _header_text
	GameEvents.emit_signal("dialogue_initiated", _slides)
	
	self.visible = true
	runtime_data.current_gameplay_state = Enums.GamePlayState.IN_DIALOG
	
	pause()


func _on_game_resumed() -> void:
	self.visible = false


func resume() -> void:
	GameEvents.emit_signal("resume_game")


func pause() -> void:
	GameEvents.emit_signal("pause_game")
