extends MarginContainer

class_name ItemUI

export(Resource) var local_item = local_item as Item


func _ready():
	GameEvents.connect("inventory_changed", self, "_on_inventory_changed")


func initial_setup(_item: Item):
	pass


func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	pass
