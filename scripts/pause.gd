extends Node


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(_delta):
	set_pause()


func _input(_event):
	set_mouse_mode()

func set_mouse_mode() -> void:
	if Input.is_action_just_pressed("pause"):
		var mouse_mode: int = Input.get_mouse_mode()
		if mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func set_pause() -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == true:
			get_tree().paused = false
		else:
			get_tree().paused = true
