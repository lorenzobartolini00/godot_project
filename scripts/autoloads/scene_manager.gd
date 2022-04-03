extends Node


export(Array, String) var level_list = Array()
export(String) onready var level_list_path = "res://scenes/levels/"
export(int) onready var current_level_index = 0

#Array LIFO in cui viene conservata la lista dei tab aperti, nell'ordine in cui sono stati aperti
export(Array, Dictionary) onready var tab_stack = []
export(Resource) var option_tab_list_resource = preload("res://my_resources/options/option_tab_list.tres") as OptionTabList
export(Array, PackedScene) var option_tab_list
export(PackedScene) onready var title_screen = preload("res://scenes/title_screen.tscn")
export(PackedScene) onready var win_screen = preload("res://scenes/win_screen.tscn")

onready var option_layer: CanvasLayer


func _ready():
	option_layer = CanvasLayer.new()
	get_tree().get_root().call_deferred("add_child", option_layer)
	option_layer.layer = 2
	
	level_list = Util.list_folder(level_list_path)
	option_tab_list = option_tab_list_resource.option_tab_list_reference
	
	
	if GameEvents.connect("play", self, "_on_play") != OK:
		print("failure")
	if GameEvents.connect("options", self, "_on_options") != OK:
		print("failure")
	if GameEvents.connect("back", self, "_on_back") != OK:
		print("failure")
	if GameEvents.connect("win", self, "_on_win") != OK:
		print("failure")
	if GameEvents.connect("exit", self, "_on_exit") != OK:
		print("failure")


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
		if get_tree().change_scene_to(win_screen) != OK:
			print("unable to change scene")
		
		current_level_index = 0


func _on_options(option_tab_index: int):
	if option_tab_index < option_tab_list.size():
		var option_tab_reference: PackedScene = option_tab_list[option_tab_index]
		var option_tab_instance: Node = load_scene(option_tab_reference, option_layer)
		
		add_tab_to_stack(option_tab_reference, option_tab_instance)


func _on_back():
	var current_tab: Dictionary = tab_stack.pop_back()
	if current_tab:
		current_tab.instance.queue_free()


func _on_win():
	current_level_index += 1
#	SaveManager.save_data()
	
	GameEvents.emit_signal("play", current_level_index)


func _on_exit():
	get_tree().quit()
	

func load_scene(scene: PackedScene, parent: Node) -> Node:
	var scene_instance: Node = scene.instance()
	parent.add_child(scene_instance)
	
	return scene_instance


func add_tab_to_stack(reference: PackedScene, instance: Tab) -> void:
	var dicionary_element: Dictionary = {
	reference = reference,
	instance = instance}
		
	tab_stack.append(dicionary_element)


func get_main_scene() -> Node:
	return get_tree().get_root().get_node("Level")
