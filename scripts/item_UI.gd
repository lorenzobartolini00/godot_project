extends MarginContainer

class_name ItemUI

export(NodePath) onready var avatar = get_node(avatar) as TextureRect
export(NodePath) onready var name_label = get_node(name_label) as Label
export(NodePath) onready var description_label = get_node(description_label) as Label


func initial_setup(_item: Item):
	avatar.texture = _item.get_avatar()
	name_label.text = _item.name


func update_information(_text: String) -> void:
	description_label.text = _text


