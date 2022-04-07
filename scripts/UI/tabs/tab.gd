extends Control

class_name Tab

export(Array, Dictionary) onready var tab_reference_list = [
	{
		option_tab_name = "title_screen",
		option_tab_path = "res://scenes/title_screen.tscn"
	},
	{
		option_tab_name = "options",
		option_tab_path = "res://nodes/UI/option_tabs/options_UI.tscn"
	},
	{
		option_tab_name = "comand_list",
		option_tab_path = "res://nodes/UI/option_tabs/comand_list_UI.tscn"
	},
	{
		option_tab_name = "game_over",
		option_tab_path = "res://nodes/UI/game_over_UI.tscn"
	},
	{
		option_tab_name = "pause",
		option_tab_path = "res://nodes/UI/pause_UI.tscn"
	},
	{
		option_tab_name = "win_screen",
		option_tab_path = "res://scenes/win_screen.tscn"
	}
	]
	
export(Resource) onready var global_runtime_data = preload("res://my_resources/runtime_data/global_runtime_data.tres") as RuntimeData
export(String) onready var tab_name
export(bool) onready var is_root
export(bool) onready var focus


func _ready():
	if GameEvents.connect("tab_selected", self, "_on_tab_selected") != OK:
		print("failure")
	if GameEvents.connect("change_tab_to", self, "_on_change_tab_to") != OK:
		print("failure")

	GameEvents.emit_tab_selected(self)

	if get_is_root():
		TabManager.clear_tab_stack()

	TabManager.add_tab_to_stack(self)


func _on_change_tab_to(name: String):
	if get_focus():
		var option_tab = self.get_tab_instance(name)
		if option_tab:
			add_child(option_tab)


func _on_tab_selected(tab):
	var is_tab_selected: bool = tab == self

	self.set_focus(is_tab_selected)


func get_tab_reference(name: String) -> Resource:
	for dictionary_element in tab_reference_list:
		if dictionary_element.option_tab_name == name:
			return load(dictionary_element.option_tab_path)

	return null


func get_tab_instance(name: String):
	var tab_reference: PackedScene = get_tab_reference(name)
	var tab_instance = null

	if tab_reference:
		tab_instance = tab_reference.instance()

	return tab_instance


func set_focus(_focus: bool) -> void:
	focus = _focus


func get_focus() -> bool:
	return focus


func set_is_root(_is_root: bool) -> void:
	is_root = _is_root


func get_is_root() -> bool:
	return is_root


