extends GridContainer

onready var life_item_UI = preload("res://nodes/UI/life_item_UI.tscn")


func _ready():
	if GameEvents.connect("inventory_changed", self, "_on_inventory_changed") != OK:
		print("failure")


func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	_update_life_container_UI(_inventory, _item_changed)


func _update_life_container_UI(_inventory: Inventory, _item_changed: Dictionary):
	var _item: Item = _item_changed.item_reference
	var _quantity: int = _item_changed.quantity
	var _status: int = _item_changed.status
	
	var current_number_of_slots: int = self.get_children().size()
	
	if _item is LifeSlot:
		if _status == Enums.ItemStatus.UNLOCKED:
			while current_number_of_slots < _quantity:
				var _life_item_UI = life_item_UI.instance() as LifeItemUI
				self.add_child(_life_item_UI)
		
				_life_item_UI.setup(_item, _inventory)
				
				current_number_of_slots = self.get_children().size()
