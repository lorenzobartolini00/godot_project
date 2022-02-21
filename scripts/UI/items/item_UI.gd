extends MarginContainer

class_name ItemUI

var local_item: Item

export(NodePath) onready var avatar = get_node(avatar) as TextureRect
export(NodePath) onready var name_label = get_node(name_label) as Label
export(NodePath) onready var description_label = get_node(description_label) as Label


func _ready():
	GameEvents.connect("inventory_changed", self, "_on_inventory_changed")


func initial_setup(_item: Item):
	local_item = _item
	avatar.texture = _item.get_avatar()
	name_label.text = _item.name


func _on_inventory_changed(inventory: Inventory, _item_changed: Dictionary):
	pass
