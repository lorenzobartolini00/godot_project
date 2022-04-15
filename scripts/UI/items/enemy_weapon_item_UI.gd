extends GenericWeaponItemUI

class_name EnemyWeaponItemUI

func _update_UI(_weapon: Weapon) -> void:
	var ammo: Ammo = _weapon.get_ammo()
	if _weapon.get_ammo():
		var _ammo_in_mag: String = String(_weapon.ammo_in_mag)
		
		var _new_description_text: String = _ammo_in_mag
		
		self.description_label.text = _new_description_text
		self.ammo_avatar.texture = ammo.get_avatar()
	else:
		self.description_label.text = String("0")
