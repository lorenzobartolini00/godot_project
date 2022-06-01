extends Node


export(Array, String) var level_list = Array()
export(String) onready var level_list_path = "res://scenes/levels/"
export(int) onready var current_level_index = 0


export(String) onready var title_screen = "res://scenes/background/title_screen.tscn"
export(String) onready var win_screen = "res://scenes/win_screen.tscn"


func _ready():
	level_list = Util.list_folder(level_list_path)
	
	if GameEvents.connect("play", self, "_on_play") != OK:
		print("failure")
	if GameEvents.connect("win", self, "_on_win") != OK:
		print("failure")
	if GameEvents.connect("title_screen", self, "_on_title_screen") != OK:
		print("failure")
	if GameEvents.connect("exit", self, "_on_exit") != OK:
		print("failure")

#Debug
func _process(_delta):
	if Input.is_action_just_pressed("change_level"):
		current_level_index += 1
		GameEvents.emit_signal("play", current_level_index)


func _on_play(level_index: int):
	if level_index < level_list.size():
		var main_scene = level_list[level_index]
		
		if get_tree().change_scene(main_scene) != OK:
			print("unable to change scene")
	else:
		if get_tree().change_scene(win_screen) != OK:
			print("unable to change scene")
		
		current_level_index = 0


func _on_win():
	current_level_index += 1
	GameEvents.emit_signal("play", current_level_index)


func _on_title_screen():
	if get_tree().change_scene(title_screen) != OK:
		print("unable to change scene")


func _on_exit():
	get_tree().quit()


func get_main_scene() -> Node:
	return get_tree().get_root().get_node("Level")
