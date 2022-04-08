extends WeaponItemUI

class_name BlasterItemUI

export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress


func _update_UI(_weapon: Weapon) -> void:
	var ammo: Ammo = _weapon.get_ammo()
	if ammo:
		var _ammo_in_stock: int = inventory.get_item_quantity(ammo)
		
		var _ammo_in_mag: int = _weapon.ammo_in_mag
		var mag_size: int = _weapon.mag_size
		
		self.progress_bar.value = _ammo_in_mag
		self.progress_bar.max_value = mag_size
	
