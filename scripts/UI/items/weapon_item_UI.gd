extends ItemUI

class_name WeaponItemUI

export(NodePath) onready var weapon_avatar = get_node(weapon_avatar) as TextureRect
export(NodePath) onready var ammo_avatar = get_node(ammo_avatar) as TextureRect

export(NodePath) onready var name_label = get_node(name_label) as Label
export(NodePath) onready var description_label = get_node(description_label) as Label



func _ready():
	GameEvents.connect("current_ammo_changed", self, "_on_current_ammo_changed")


func setup(_weapon_item: Item, _inventory: Inventory):
	if _weapon_item is Weapon:
		self.local_item = _weapon_item
		self.inventory = _inventory
		
		self.weapon_avatar.texture = _weapon_item.get_avatar()
		self.name_label.text = _weapon_item.name
		_update_UI(_weapon_item, _weapon_item.get_ammo())


func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	var _item = _item_changed.item_reference as Item

	if _item is Ammo:
		if _item.name == self.name_label.text + "_ammo":
			var weapon: Weapon = self.local_item
			
			_update_UI(weapon, _item)


func _on_current_ammo_changed(_weapon: Weapon, _ammo: Ammo, character: Character):
	if character is Player:
		if _ammo.name == self.name_label.text + "_ammo":
			_update_UI(_weapon, _ammo)


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
