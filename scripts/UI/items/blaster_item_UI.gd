extends WeaponItemUI

class_name BlasterItemUI

export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress


func setup(_weapon_item: Item, _inventory: Inventory):
	if _weapon_item is Weapon:
		self.local_item = _weapon_item
		self.inventory = _inventory
		
		self.name_label.text = _weapon_item.name
		_update_UI(_weapon_item, _weapon_item.get_ammo())


func _update_UI(_weapon: Weapon, _ammo: Ammo) -> void:
	if _ammo:
		var _ammo_in_stock: int = inventory.get_item_quantity(_ammo)
		
		var _current_ammo: int = _weapon.current_ammo
		var _max_ammo: int = _ammo.max_ammo
		
		self.progress_bar.value = _current_ammo
		self.progress_bar.max_value = _max_ammo
	
