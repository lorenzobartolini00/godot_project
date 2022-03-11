extends Node


export(Array, String) var level_list = Array()
export(String) onready var level_list_path = "res://scenes/levels/"
export(int) var current_level_index = 0

#Array LIFO in cui viene conservata la lista dei tab aperti, nell'ordine in cui sono stati aperti
export(Array, Dictionary)onready var tab_stack = []
export(Resource) var option_tab_list_resource = preload("res://my_resources/options/option_tab_list.tres") as OptionTabList
export(Array, PackedScene) var option_tab_list

onready var option_layer: CanvasLayer

func _ready():
	option_layer = CanvasLayer.new()
	get_tree().get_root().call_deferred("add_child", option_layer)
	option_layer.layer = 2
	
	level_list = Util.list_folder(level_list_path)
	option_tab_list = option_tab_list_resource.option_tab_list_reference
	
	GameEvents.connect("play", self, "_on_play")
	GameEvents.connect("options", self, "_on_options")
	GameEvents.connect("back", self, "_on_back")
	GameEvents.connect("exit", self, "_on_exit")


func _on_play(level_index: int):
	if level_index < level_list.size():
		get_tree().change_scene(level_list[level_index])


func _on_options(option_tab_index: int):
	if option_tab_index < option_tab_list.size():
		var option_tab_reference: PackedScene = option_tab_list[option_tab_index]
		var option_tab_instance: Node = load_scene(option_tab_reference, option_layer)
		
		add_tab_to_stack(option_tab_reference, option_tab_instance)


func _on_back():
	var current_tab: Dictionary = tab_stack.pop_back()
	if current_tab:
		current_tab.instance.queue_free()


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
