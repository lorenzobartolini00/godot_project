extends Control

export(NodePath) onready var _ammo_label = get_node(_ammo_label) as Label
export(NodePath) onready var _life_label = get_node(_life_label) as Label
export(NodePath) onready var _weapon_label = get_node(_weapon_label) as Label
export(NodePath) onready var _warning_label = get_node(_warning_label) as Label

export(NodePath) onready var _warning_animation_player = get_node(_warning_animation_player) as AnimationPlayer
export(NodePath) onready var _weapon_grid_container = get_node(_weapon_grid_container) as GridContainer

onready var item_UI = preload("res://nodes/item_UI.tscn")


func _ready():
	GameEvents.connect("reload", self, "_on_reloading")
	GameEvents.connect("warning", self, "_on_warning")
	
	GameEvents.connect("life_changed", self, "_on_life_changed")
	GameEvents.connect("ammo_changed", self, "_on_ammo_changed")
	GameEvents.connect("weapon_changed", self, "_on_weapon_changed")
	
	GameEvents.connect("show_weapon_list", self, "_on_show_weapon_list")
	


func _on_life_changed(_new_life: int, character: Character):
	if character is Player:
		set_life_text(String(_new_life))


func _on_ammo_changed(_ammo: Ammo, character: Character):
	if character is Player:
		if _ammo:
			set_ammo_text(String(_ammo.current_ammo)+"/"+String(_ammo.max_ammo))
		else:
			set_ammo_text(String("0")+"/"+String("0"))


func _on_weapon_changed(_weapon: Weapon, character: Character):
	if character is Player:
		if _weapon:
			set_weapon_text(String(_weapon.name))
		else:
			set_weapon_text(String("No weapon"))


func _on_show_weapon_list(_weapon_list: Array) -> void:
	for _weapon_item in _weapon_list:
		var _weapon = _weapon_item.item_reference as Weapon
		
		var _item_UI = item_UI.instance() as ItemUI
		_item_UI.setup(_weapon.get_avatar(), _weapon.name)
		_weapon_grid_container.add_child(_item_UI)


func _on_warning(_text: String) -> void:
	_warning_label.text = _text
	if not _warning_animation_player.is_playing():
		_warning_animation_player.play("warning")


func _on_reloading(character: Character):
	if character is Player:
		set_ammo_text("Reloading...")


func set_ammo_text(_text: String) -> void:
	_ammo_label.text = _text


func set_life_text(_text: String) -> void:
	_life_label.text = _text


func set_weapon_text(_text: String) -> void:
	_weapon_label.text = _text
