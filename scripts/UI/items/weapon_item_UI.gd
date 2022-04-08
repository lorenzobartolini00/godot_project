extends ItemUI

class_name WeaponItemUI

export(NodePath) onready var weapon_avatar = get_node(weapon_avatar) as TextureRect
export(NodePath) onready var name_label = get_node(name_label) as Label


onready var weapon_name: String = ""

func _ready():
	if GameEvents.connect("ammo_changed", self, "_on_ammo_changed") != OK:
		print("failure")


func setup(_weapon_item: Item, _inventory: Inventory):
	if _weapon_item is Weapon:
		self.local_item = _weapon_item
		self.inventory = _inventory
		
		self.weapon_avatar.texture = _weapon_item.get_avatar()
		self.name_label.text = _weapon_item.display_name
		
		weapon_name = _weapon_item.name
		_update_UI(_weapon_item)


func _update_UI(_weapon: Weapon) -> void:
	pass


func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	var _item = _item_changed.item_reference as Item

	if _item is Ammo:
		if _item.name == weapon_name + "_ammo":
			var weapon: Weapon = self.local_item
			
			_update_UI(weapon)


func _on_ammo_changed(_weapon: Weapon, character: Character):
	if character is Player:
		if _weapon.name == weapon_name:
			_update_UI(_weapon)

