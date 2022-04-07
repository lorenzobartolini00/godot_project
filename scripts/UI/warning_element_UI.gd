extends Control

class_name WarningElement

export(NodePath) onready var warning_label = get_node(warning_label) as Label


func setup(text: String):
	warning_label.text = text
