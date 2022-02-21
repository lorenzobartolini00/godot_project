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
	
	GameEvents.connect("life_changed", self, "_on_life_changed")
	GameEvents.connect("current_weapon_changed", self, "_on_current_weapon_changed")
	GameEvents.connect("found_new_item", self, "_on_found_new_item")
	
	_warning_label.visible = false


func _on_life_changed(_life: Life, character: Character):
	if character is Player:
		if _current_life_container.get_child_count() == 0:
			var _life_item_UI = life_item_UI.instance() as LifeItemUI
			_current_life_container.add_child(_life_item_UI)

			_life_item_UI.initial_setup(_life)


func _on_current_weapon_changed(_weapon: Weapon, character: Character):
	if character is Player:
		if _current_weapon_container.get_child_count() != 0:
			var _previous_weapon_item: WeaponItemUI = _current_weapon_container.get_child(0)
			_current_weapon_container.remove_child(_previous_weapon_item)
		
		var _weapon_item_UI = weapon_item_UI.instance() as WeaponItemUI
		_current_weapon_container.add_child(_weapon_item_UI)
		
		_weapon_item_UI.initial_setup(_weapon)


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


func _on_found_new_item(_item: Item) ->void:
	if _item is Weapon:
		var _weapon_item_UI = weapon_item_UI.instance() as WeaponItemUI
		_weapon_grid_container.add_child(_weapon_item_UI)
		
		_weapon_item_UI.initial_setup(_item)
