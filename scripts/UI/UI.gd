extends Control

class_name UI

export(NodePath) onready var _warning_label = get_node(_warning_label) as Label

export(NodePath) onready var _warning_animation_player = get_node(_warning_animation_player) as AnimationPlayer
export(NodePath) onready var _weapon_grid_container = get_node(_weapon_grid_container) as GridContainer

export(NodePath) onready var _current_weapon_container = get_node(_current_weapon_container) as Control
export(NodePath) onready var _current_life_container = get_node(_current_life_container) as Control

onready var weapon_item_UI = preload("res://nodes/weapon_item_UI.tscn")
onready var life_item_UI = preload("res://nodes/life_item_UI.tscn")


func _ready():
	GameEvents.connect("reload", self, "_on_reloading")
	GameEvents.connect("warning", self, "_on_warning")
	
	GameEvents.connect("inventory_changed", self, "_on_inventory_changed")
	GameEvents.connect("current_weapon_changed", self, "_on_current_weapon_changed")
	
	_warning_label.visible = false

func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	_update_weapon_container_UI(_inventory, _item_changed)
	_update_life_container_UI(_inventory, _item_changed)


func _on_current_weapon_changed(_weapon: Weapon, character: Character):
	if character is Player:
		if _current_weapon_container.get_child_count() != 0:
			var _previous_weapon_item: WeaponItemUI = _current_weapon_container.get_child(0)
			_current_weapon_container.remove_child(_previous_weapon_item)
		
		var _weapon_item_UI = weapon_item_UI.instance() as WeaponItemUI
		_current_weapon_container.add_child(_weapon_item_UI)
		
		_weapon_item_UI.setup(_weapon, character.inventory)


func _on_warning(_text: String) -> void:
	if _warning_label.visible == false:
		_warning_label.visible = true
	
	_warning_label.text = _text
	if not _warning_animation_player.is_playing():
		_warning_animation_player.play("warning")


func _on_reloading(character: Character):
	if character is Player:
		if _warning_label.visible == false:
			_warning_label.visible = true
		
		_warning_label.text = "Reloading..."
		if not _warning_animation_player.is_playing():
			_warning_animation_player.play("warning")


func _update_weapon_container_UI(_inventory: Inventory, _item_changed: Dictionary):
	var _item: Item = _item_changed.item_reference
	
	if _item is Weapon and _item_changed.status != Enums.ItemStatus.LOCKED:
		var _weapon_item_UI_list: Array = _weapon_grid_container.get_children()
		var _weapon_list: Array = _inventory.get_item_list(Enums.ItemTipology.WEAPON)
	
		var found: bool = false
	
		for _weapon_item_UI in _weapon_item_UI_list:
			_weapon_item_UI = _weapon_item_UI as WeaponItemUI
			if _weapon_item_UI.name_label.text != _item.name:
				continue
			
			found = true
		
		if not found:
			var _weapon_item_UI = weapon_item_UI.instance() as WeaponItemUI
			_weapon_grid_container.add_child(_weapon_item_UI)

			_weapon_item_UI.setup(_item, _inventory)


func _update_life_container_UI(_inventory: Inventory, _item_changed: Dictionary):
	var _item: Item = _item_changed.item_reference
	
	if _item is LifeSlot:
		var _life_item_UI = life_item_UI.instance() as LifeItemUI
		_current_life_container.add_child(_life_item_UI)
