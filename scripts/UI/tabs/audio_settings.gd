extends Tab

class_name AudioSettings


export(NodePath) onready var master_slider = get_node(master_slider) as SliderElement
export(NodePath) onready var music_slider = get_node(music_slider) as SliderElement
export(NodePath) onready var effects_slider = get_node(effects_slider) as SliderElement

export(NodePath)onready var name_label = get_node_or_null(name_label) as Label


func _ready():
	name_label.text = tab_name
	
	if master_slider.connect("slider_changed", self, "_on_slider_changed") != OK:
		print("failure")
	if music_slider.connect("slider_changed", self, "_on_slider_changed") != OK:
		print("failure")
	if effects_slider.connect("slider_changed", self, "_on_slider_changed") != OK:
		print("failure")


func _on_slider_changed(slider_element: SliderElement, value: float):
	match slider_element:
		master_slider:
			change_volume(AudioServer.get_bus_index("Master") , linear2db(value))
		music_slider:
			change_volume(AudioServer.get_bus_index("Music"), linear2db(value))
		effects_slider:
			change_volume(AudioServer.get_bus_index("Effects"), linear2db(value))


func change_volume(bus_idx: int, value: float):
	AudioServer.set_bus_volume_db(bus_idx, value)
