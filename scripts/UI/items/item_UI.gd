extends MarginContainer

class_name ItemUI

var local_item: Item
var character: Character

func _ready():
	if GameEvents.connect("inventory_changed", self, "_on_inventory_changed") != OK:
		print("failure")


func setup(_item: Item, _character: Character):
	self.local_item = _item
	self.character = _character


func _on_inventory_changed(character: Character, _inventory: Inventory, _item_changed: Dictionary):
	if character is Player:
		pass
