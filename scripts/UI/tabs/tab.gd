extends Control

class_name Tab

export(NodePath)onready var name_label = get_node(name_label) as Label
export(NodePath) onready var button_container = get_node(button_container) as ButtonContainer
export(Resource)var runtime_data = runtime_data as RuntimeData

export(bool) onready var selected


func _ready():
	GameEvents.connect("back", self, "_on_back")
	GameEvents.connect("tab_selected", self, "_on_tab_selected")


func add_to_stack() -> void:
	SceneManager.add_tab_to_stack(null, self)


func _on_tab_selected(tab: Tab):
	if tab == self:
		print("active: " + name_label.text)
		selected = true
		button_container.set_active(true)
	else:
		print("disactive: " + name_label.text)
		selected = false
		button_container.set_active(false)


func _on_back():
	var current_dictionary_tab: Dictionary = SceneManager.tab_stack.back()
	var current_tab: Tab = current_dictionary_tab.instance
	
	if current_tab == self:
		GameEvents.emit_tab_selected(self)
