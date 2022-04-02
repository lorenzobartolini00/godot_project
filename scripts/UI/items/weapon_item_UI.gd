extends ItemUI

class_name WeaponItemUI

export(NodePath) onready var weapon_avatar = get_node(weapon_avatar) as TextureRect
export(NodePath) onready var name_label = get_node(name_label) as Label


func _ready():
	if GameEvents.connect("current_ammo_changed", self, "_on_current_ammo_changed") != OK:
		print("failure")


func setup(_weapon_item: Item, _inventory: Inventory):
	if _weapon_item is Weapon:
		pass


func _update_UI(_weapon: Weapon, _ammo: Ammo) -> void:
	pass


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

