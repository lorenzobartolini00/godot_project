extends Node

export(Array, String) var level_list = Array()
export(String) onready var level_list_path = "res://scenes/levels/"
export(int) var current_level_index = 0


func _ready():
	level_list = Util.list_folder(level_list_path)
	
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
