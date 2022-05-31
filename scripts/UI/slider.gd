extends Control

class_name SliderElement

export(String) onready var bus_name
export(NodePath) onready var label = get_node(label) as Label
export(NodePath) onready var slider = get_node(slider) as Slider

signal slider_changed(slider, value)


func _ready():
	label.text = bus_name
	
	set_value()


func set_value():
	var value_db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus_name))
	var value = db2linear(value_db)
	
	slider.value = value
	

func _on_HSlider_drag_ended(value_changed):
	if value_changed:
		emit_signal("slider_changed", self, slider.value)
