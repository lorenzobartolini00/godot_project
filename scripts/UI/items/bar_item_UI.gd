extends WeaponItemUI

class_name BarItemUI

export(NodePath) onready var progress_bar = get_node(progress_bar) as TextureProgress


func setup(_item: Item, _character: Character):
	.setup(_item, _character)
	
	if _item is Weapon:
		var _ammo: BarAmmo = _item.get_ammo()
	
		progress_bar.tint_progress = _ammo.bar_color


func _update_UI(_weapon: Weapon) -> void:
	var ammo: Ammo = _weapon.get_ammo()
	if ammo:
		var _ammo_in_mag: int = _weapon.ammo_in_mag
		var mag_size: int = _weapon.mag_size
		
		self.progress_bar.value = _ammo_in_mag
		self.progress_bar.max_value = mag_size
		
		if _weapon.is_charged():
			progress_bar.tint_progress = _weapon.ammo.bar_color
		else:
			progress_bar.tint_progress = _weapon.ammo.overheat_bar_color
	
