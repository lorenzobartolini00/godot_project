extends Tab

class_name InteractionTab

export(NodePath) onready var button_container = get_node(button_container) as ButtonContainer
export(NodePath)onready var name_label = get_node_or_null(name_label) as Label


func _ready():
	name_label.text = tab_name


func _on_tab_selected(tab):
	._on_tab_selected(tab)
	
	button_container.set_active(tab==self)
