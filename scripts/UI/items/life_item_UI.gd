extends ItemUI

class_name LifeItemUI

export(NodePath) onready var life_avatar = get_node(life_avatar) as TextureRect

export(NodePath) onready var name_label = get_node(name_label) as Label
export(NodePath) onready var description_label = get_node(description_label) as Label

func _ready():
	GameEvents.connect("life_changed", self, "_on_life_changed")


func initial_setup(_life: Item):
	if _life is Life:
		local_item = _life
		life_avatar.texture = _life.get_avatar()
		name_label.text = _life.name
		description_label.text = String(_life.get_current_life())


func _on_life_changed(_life: Life, character: Character):
	if character is Player:
		description_label.text = String(_life.get_current_life())
