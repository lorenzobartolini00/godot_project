extends Control

class_name WarningUI

export(NodePath) onready var warning_grid = get_node(warning_grid) as GridContainer
export(NodePath) onready var show_warning_timer = get_node(show_warning_timer) as Timer
export(PackedScene) onready var warning_label_reference

onready var warning_queue: Array = []


func _ready():
	if GameEvents.connect("warning", self, "_on_warning") != OK:
		print("failure")


func _on_warning(_text: String) -> void:
	show_warning_timer.start()
	update_warning_queue(_text)


func update_warning_queue(_text: String):
	var warning_label: WarningElement = warning_label_reference.instance()
	warning_label.call_deferred("setup", _text)
	warning_grid.add_child(warning_label)


func _on_WarningTimer_timeout():
	var last_child: WarningElement
	var warning_children: Array = warning_grid.get_children()
	
	if warning_children.size() > 0:
		last_child = warning_children.pop_front()
		warning_grid.remove_child(last_child)
