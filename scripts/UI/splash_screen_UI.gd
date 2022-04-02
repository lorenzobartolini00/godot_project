extends Tab

export(Array, Resource)onready var message_array

var queue: Array = []

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	self.visible = false
	
	if GameEvents.connect("found_new_item", self, "_on_found_new_item") != OK:
		print("failure")
	if GameEvents.connect("resume_game", self, "_on_game_resumed") != OK:
		print("failure")
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")
	if GameEvents.connect("new_mission", self, "_on_new_mission") != OK:
		print("failure")


func free_queue():
	if queue.size() > 0 and runtime_data.current_gameplay_state != Enums.GamePlayState.IN_DIALOG:
		var message: Dictionary = queue.pop_back()
		
		show_splash_message(message.text, message.slide)
		

func add_to_queue(_text: String, _slide: Slide):
	var dictionary_element: Dictionary = {
		text = _text,
		slide = _slide }
	
	queue.append(dictionary_element)


func _on_found_new_item(_item: Dictionary):
	var item: Item = _item.item_reference
	
	if not item is Ammo:
		var new_slide: Slide = message_array[Enums.MessageTipology.NEW_ITEM]
		var header_text: String = new_slide.slides[0] % item.display_name
		
		call_deferred("add_to_queue", header_text, item.description)


func _on_new_mission(level: Level):
	var new_slide: Slide = message_array[Enums.MessageTipology.NEW_MISSION]
	var header_text: String = new_slide.slides[0]
	var description: Slide = level.description
	
	call_deferred("add_to_queue", header_text, description)



func _on_died(character) -> void:
	if character.is_in_group("player"):
		self.visible = false


func show_splash_message(_header_text: String, _slides: Slide) -> void:
	self.name_label.text = _header_text
	GameEvents.emit_signal("dialogue_initiated", _slides)
	
	self.visible = true
	runtime_data.current_gameplay_state = Enums.GamePlayState.IN_DIALOG
	
	GameEvents.emit_signal("tab_selected", self)
	
	pause()


func _on_game_resumed() -> void:
	button_container.set_active(false)
	self.visible = false


func pause() -> void:
	GameEvents.emit_signal("pause_game")


func _on_FreeQueueTimer_timeout():
	free_queue()
