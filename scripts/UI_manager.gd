extends Control

export(NodePath) onready var _ammo_label = get_node(_ammo_label) as Label
export(NodePath) onready var _life_label = get_node(_life_label) as Label
export(NodePath) onready var _weapon_label = get_node(_weapon_label) as Label

func _ready():
	GameEvents.connect("reload", self, "_on_reloading")
	
	GameEvents.connect("life_changed", self, "_on_life_changed")
	GameEvents.connect("ammo_changed", self, "_on_ammo_changed")
	GameEvents.connect("weapon_changed", self, "_on_weapon_changed")
	


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


func _on_reloading(character: Character):
	if character is Player:
		set_ammo_text("Reloading...")


func set_ammo_text(_text: String) -> void:
	_ammo_label.text = _text


func set_life_text(_text: String) -> void:
	_life_label.text = _text


func set_weapon_text(_text: String) -> void:
	_weapon_label.text = _text