extends WeaponItemUI

class_name BlasterItemUI

export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress


func setup(_weapon_item: Item, _inventory: Inventory):
	if _weapon_item is Weapon:
		self.local_item = _weapon_item
		self.inventory = _inventory
		
		self.name_label.text = _weapon_item.name
		self.weapon_avatar.texture = _weapon_item.avatar
		_update_UI(_weapon_item)


func _update_UI(_weapon: Weapon) -> void:
	var ammo: Ammo = _weapon.get_ammo()
	if ammo:
		var _ammo_in_stock: int = inventory.get_item_quantity(ammo)
		
		var _ammo_in_mag: int = _weapon.ammo_in_mag
		var mag_size: int = _weapon.mag_size
		
		self.progress_bar.value = _ammo_in_mag
		self.progress_bar.max_value = mag_size
	
