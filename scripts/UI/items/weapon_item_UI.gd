extends ItemUI

class_name WeaponItemUI


func initial_setup(_weapon_item: Item):
	if _weapon_item is Weapon:
		self.local_item = _weapon_item
		self.weapon_avatar.texture = _weapon_item.get_avatar()
		self.name_label.text = _weapon_item.name	


func _on_inventory_changed(inventory: Inventory, _item_changed: Dictionary):
	var _item = _item_changed.item_reference as Item
	
	if _item is Ammo:
		if _item.name == self.local_item.get_ammo().name:
			var _new_description_text: String = String(_item_changed.quantity) \
				+ "/" \
				+ String(_item.max_quantity)
			
			self.ammo_avatar.texture = _item.get_avatar()
			self.description_label.text = _new_description_text
