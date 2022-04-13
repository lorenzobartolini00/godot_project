extends Node

#Array LIFO in cui viene conservata la lista dei tab aperti, nell'ordine in cui sono stati aperti
export(Array, Dictionary) onready var tab_stack = []
export(Array, PackedScene) var option_tab_list


func _ready():
	if GameEvents.connect("back", self, "_on_back") != OK:
		print("failure")


func _on_back():
	var current_tab: Tab
	
	if tab_stack.size() > 0:
		current_tab = tab_stack[tab_stack.size() - 1]
	
		if current_tab.get_is_root():
			pass
		else:
			tab_stack.remove(tab_stack.size() - 1)
			current_tab.queue_free()
			
			current_tab = tab_stack[tab_stack.size() - 1]
				
			GameEvents.emit_signal("tab_selected", current_tab)


func add_tab_to_stack(tab) -> void:
	tab_stack.append(tab)


func clear_tab_stack():
	tab_stack.clear()


func clear_tab_stack_to_root():
	var root: Tab
	
	for tab in tab_stack:
		if is_instance_valid(tab):
			if not tab.get_is_root():
				tab.queue_free()
			else:
				root = tab
	
	tab_stack.clear()
	tab_stack.append(root)


func get_current_tab() -> Tab:
	if tab_stack.size() > 0:
		return tab_stack[tab_stack.size() - 1]
	else:
		return null


func get_root_tab() -> Tab:
	var root: Tab
	
	for tab in tab_stack:
		if is_instance_valid(tab):
			if not tab.get_is_root():
				continue
			else:
				root = tab
	
	return root


func is_tab_in_stack(tab: Tab) -> bool:
	var index: int = tab_stack.find(tab)
	
	return index >= 0


func is_current_tab_root() -> bool:
	return get_current_tab().get_is_root()
