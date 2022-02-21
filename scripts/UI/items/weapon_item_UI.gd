extends ItemUI

class_name WeaponItemUI

export(NodePath) onready var weapon_avatar = get_node(weapon_avatar) as TextureRect
export(NodePath) onready var ammo_avatar = get_node(ammo_avatar) as TextureRect

export(NodePath) onready var name_label = get_node(name_label) as Label
export(NodePath) onready var description_label = get_node(description_label) as Label

func _ready():
	GameEvents.connect("ammo_changed", self, "_on_ammo_changed")

func initial_setup(_weapon_item: Item):
	if _weapon_item is Weapon:
		self.local_item = _weapon_item
		self.weapon_avatar.texture = _weapon_item.get_avatar()
		self.name_label.text = _weapon_item.name


func _on_inventory_changed(inventory: Inventory, _item_changed: Dictionary):
	var _item = _item_changed.item_reference as Item
	
	if _item is Ammo:
		if _item.name == self.local_item.get_ammo().name:
			var _ammo_in_stock: int = _item_changed.quantity
			
			_update_ammo_statistics(_item, _ammo_in_stock)


func _on_ammo_changed(_ammo: Ammo, character: Character):
	if character is Player:
		if _ammo:
			if _ammo.name == self.local_item.get_ammo().name:
				var _ammo_in_stock: int = _get_ammo_in_stock(_ammo, character)
				_update_ammo_statistics(_ammo, _ammo_in_stock)
		else:
			self.description_label.text = String("0")+"/"+String("0")
			pass


func _update_ammo_statistics(_ammo: Ammo, _ammo_in_stock: int) -> void:
	var _current_ammo: String = String(_ammo.current_ammo)
	var _remaining_ammo: String = String(_ammo.max_ammo * _ammo_in_stock)
	
	var _new_description_text: String = _current_ammo\
		+ "/"\
		+ _remaining_ammo
				
	self.description_label.text = _new_description_text
	self.ammo_avatar.texture = _ammo.get_avatar()


func _get_ammo_in_stock(_ammo: Ammo, _character: Character) -> int:
	if _character is Player:
	
		var _ammo_list = _character.get_inventory().get_items()[Enums.ItemTipology.AMMO]

		for _ammo_item in _ammo_list:
			if _ammo_item.item_reference.name != _ammo.name:
				continue

			return _ammo_item.quantity
	
	return 0
