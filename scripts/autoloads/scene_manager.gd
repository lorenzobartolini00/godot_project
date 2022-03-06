extends Node

export(Array, String) var level_list = Array()
export(String) onready var level_list_path = "res://scenes/levels/"


func _ready():
	update_level_list(level_list_path)
	
	GameEvents.connect("play", self, "_on_play")
	GameEvents.connect("options", self, "_on_options")
	GameEvents.connect("exit", self, "_on_exit")


func _on_play(level_index: int):
	if level_index < level_list.size():
		get_tree().change_scene(level_list[level_index])


func _on_options():
	pass


func _on_exit():
	get_tree().quit()


func update_level_list(path: String) -> void:
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				level_list.append(String(path + file_name))
				
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
