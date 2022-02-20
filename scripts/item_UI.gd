extends MarginContainer

class_name ItemUI

export(NodePath) onready var avatar
export(NodePath) onready var description_label

func setup(_texture: Texture, _text: String):
	get_node(avatar).texture = _texture
	get_node(description_label).text = _text

