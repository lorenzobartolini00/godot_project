extends Node

#Array LIFO in cui viene conservata la lista dei tab aperti, nell'ordine in cui sono stati aperti
export(Array, Dictionary) onready var tab_stack = []
export(Array, PackedScene) var option_tab_list


func _ready():
	if GameEvents.connect("back", self, "_on_back") != OK:
		print("failure")


func _on_back():
	var current_tab = tab_stack.pop_back()
	
	if not current_tab.get_is_root():
		current_tab.queue_free()
		
		var previous_tab
	
		if tab_stack.size() > 0:
			previous_tab = tab_stack[tab_stack.size() - 1]
			
			GameEvents.emit_signal("tab_selected", previous_tab)


func add_tab_to_stack(tab) -> void:
	tab_stack.append(tab)


func clear_tab_stack():
	for tab in tab_stack:
		if is_instance_valid(tab):
			tab.queue_free()
	
	tab_stack.clear()
