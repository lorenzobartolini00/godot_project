extends Control

export(NodePath)onready var splash_message_label = get_node(splash_message_label) as Label
export(NodePath)onready var description_label = get_node(description_label) as Label
export(Array, String, MULTILINE) var message_array

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	self.visible = false
	
	GameEvents.connect("found_new_item", self, "_on_found_new_item")
	GameEvents.connect("resume_game", self, "_on_game_resumed")


func _on_found_new_item(_item: Dictionary):
	var item: Item = _item.item_reference
	
	var splash_message_text: String = message_array[Enums.MessageTipology.NEW_ITEM] + item.name
	var description_text: String = item.description
	
		
	show_splash_message(splash_message_text, description_text)


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE and self.visible:
			call_deferred("resume")


func show_splash_message(_splash_message_text: String, _description_text: String) -> void:
	splash_message_label.text = _splash_message_text
	description_label.text = _description_text
	self.visible = true
	
	pause()


func _on_game_resumed() -> void:
	self.visible = false


func resume() -> void:
	GameEvents.emit_signal("resume_game")


func pause() -> void:
	GameEvents.emit_signal("pause_game")
