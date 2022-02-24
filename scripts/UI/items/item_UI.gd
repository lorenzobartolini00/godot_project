extends MarginContainer

class_name ItemUI

var local_item: Item
var inventory: Inventory

func _ready():
	GameEvents.connect("inventory_changed", self, "_on_inventory_changed")


func setup(_item: Item, _inventory: Inventory):
	self.local_item = _item
	self.inventory = _inventory


func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	pass
