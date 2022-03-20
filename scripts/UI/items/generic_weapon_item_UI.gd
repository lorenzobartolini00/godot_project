extends WeaponItemUI

class_name GenericWeaponItemUI

export(NodePath) onready var description_label = get_node(description_label) as Label
export(NodePath) onready var ammo_avatar = get_node(ammo_avatar) as TextureRect


func setup(_weapon_item: Item, _inventory: Inventory):
	if _weapon_item is Weapon:
		self.local_item = _weapon_item
		self.inventory = _inventory
		
		self.weapon_avatar.texture = _weapon_item.get_avatar()
		self.name_label.text = _weapon_item.name
		_update_UI(_weapon_item, _weapon_item.get_ammo())


func _update_UI(_weapon: Weapon, _ammo: Ammo) -> void:
	if _ammo:
		var _ammo_in_stock: int = inventory.get_item_quantity(_ammo)
		
		var _current_ammo: String = String(_weapon.current_ammo)
		var _remaining_ammo: String = String(_ammo.max_ammo * _ammo_in_stock)
		
		var _new_description_text: String = _current_ammo\
			+ "/"\
			+ _remaining_ammo
		
		self.description_label.text = _new_description_text
		self.ammo_avatar.texture = _ammo.get_avatar()
	else:
		self.description_label.text = String("0")+"/"+String("0")
