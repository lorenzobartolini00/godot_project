extends Node

export(NodePath)onready var description_label = get_node(description_label) as Label
export(Resource)var runtime_data = runtime_data as RuntimeData

export(Resource)var _current_slides = _current_slides as Slide

var _current_slide_index := 0


func _ready():
	GameEvents.connect("advance_slide", self, "_on_advance_slide")
	
	GameEvents.connect("dialogue_initiated", self, "_on_dialogue_initiated")
	GameEvents.connect("dialogue_finished", self, "_on_dialogue_finished")


#func _input(event):
#	if Input.is_action_just_pressed("jump"):
#		pass


func _on_advance_slide():
	if _current_slide_index < _current_slides.slides.size() - 1:
		_current_slide_index += 1
		show_slide()
	elif runtime_data.current_gameplay_state == Enums.GamePlayState.IN_DIALOG:
		GameEvents.emit_dialog_finished()


func _on_dialogue_initiated(_slides: Slide) -> void:
	runtime_data.current_gameplay_state = Enums.GamePlayState.IN_DIALOG
	set_dialogue(_slides)
	show_slide()


func _on_dialogue_finished() -> void:
	GameEvents.emit_resume_game()
	pass


func set_dialogue(slides: Slide) -> void:
	_current_slides = slides
	_current_slide_index = 0


func show_slide() -> void:
	description_label.text = _current_slides.slides[_current_slide_index]
