extends Node

func _process(_delta):
	if Input.is_action_just_pressed("save"):
		save_data()
	if Input.is_action_just_pressed("load"):
		load_data()


func save_data():
	pass


func load_data():
	pass
