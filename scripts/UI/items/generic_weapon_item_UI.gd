extends WeaponItemUI

class_name GenericWeaponItemUI

export(NodePath) onready var description_label = get_node(description_label) as Label
export(NodePath) onready var ammo_avatar = get_node(ammo_avatar) as TextureRect



func _update_UI(_weapon: Weapon) -> void:
	var ammo: Ammo = _weapon.get_ammo()
	if _weapon.get_ammo():
		var inventory: Inventory 
		var _ammo_in_stock: int = 0
		var _remaining_ammo: String = "-"
		
		if character is Player:
			inventory = character.get_inventory()
			_ammo_in_stock = inventory.get_item_quantity(ammo)
			
			_remaining_ammo = String(_ammo_in_stock)
		
		var _ammo_in_mag: String = String(_weapon.ammo_in_mag)
		
		var _new_description_text: String = _ammo_in_mag\
			+ "/"\
			+ _remaining_ammo
		
		self.description_label.text = _new_description_text
		self.ammo_avatar.texture = ammo.get_avatar()
	else:
		self.description_label.text = String("0")+"/"+String("0")
