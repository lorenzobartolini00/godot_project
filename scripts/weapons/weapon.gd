extends Usable

class_name Weapon


export(int) var damage
export(Resource) var ammo = ammo as Ammo
export(int) var current_ammo
export(PackedScene) var muzzle_flash = preload("res://nodes/muzzle_flash.tscn")
export(Dictionary) onready var sound_list = {
	"shoot": [preload("res://assets/my_assets/sounds/cut_sounds/pistol.wav")],
	"explosion": [preload("res://assets/my_assets/sounds/pixabay_sound_effects/musket-explosion-6383.mp3")],
	"reload": [preload("res://assets/my_assets/sounds/pixabay_sound_effects/1911-reload-6248.mp3")],
	"empty_shoot": [preload("res://assets/my_assets/sounds/pixabay_sound_effects/empty-gun-shot-6209.mp3")]
	}
export(String) var weapon_item_UI_path = "res://nodes/UI/weapon_item_UI.tscn"


var explosion_sound: Object = preload("res://assets/my_assets/sounds/pixabay_sound_effects/musket-explosion-6383.mp3")


func use(_character):
#	if _character.is_in_group("player"):
#		GameEvents.emit_signal("change_current_weapon", self, _character)
	pass


func shoot(_character) -> void:
	pass


func set_ammo(_ammo: Ammo) -> void:
	ammo = _ammo


func get_ammo() -> Ammo:
	return ammo


func get_sound_list() -> Dictionary:
	return sound_list
