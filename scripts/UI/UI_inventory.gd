extends UIComponent

class_name InventoryUI

func _ready():
	GameEvents.connect("inventory_changed", self, "_on_inventory_changed")
	GameEvents.connect("found_new_item", self, "_on_found_new_item")

func _on_found_new_item(_item: Item) ->void:
	if _item is Weapon:
		var _item_UI = ui.item_UI.instance() as ItemUI
		_item_UI.call_deferred("initial_setup", _item)
		
		ui._weapon_grid_container.add_child(_item_UI)


func _on_inventory_changed(inventory: Inventory) -> void:
	var _weapon_list = inventory.get_items()[Enums.ItemTipology.WEAPON]
	var _ammo_list = inventory.get_items()[Enums.ItemTipology.AMMO]
	
	for _weapon_item in _weapon_list:
		var _item_UI_list = ui._weapon_grid_container.get_children()
		
		var _item_UI_to_update: ItemUI
		var _ammo: Ammo
		
		for _item_UI in _item_UI_list:
			if _weapon_item.item_reference.name != _item_UI.name_label.text:
				continue
			
			_item_UI_to_update = _item_UI
			break
		
		for _ammo_item in _ammo_list:
			if _ammo_item.item_reference.name != _weapon_item.item_reference.name + "_ammo":
				continue
			
			_item_UI_to_update.update_information(String(_ammo_item.quantity) + "/"+ String(_weapon_item.item_reference.get_ammo().max_quantity))
