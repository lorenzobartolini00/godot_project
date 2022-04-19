extends Area

class_name Interactable

var is_used: bool setget set_is_used, get_is_used
var is_active: bool = true setget set_is_active, get_is_active

func _ready():
	if GameEvents.connect("interact", self, "_on_interact") != OK:
		print("failure")


func _on_interact(character: Character, interactable_object):
	if interactable_object == self and is_active:
		print(character.name + " has interacted with " + get_parent().name)


func set_is_used(_is_used: bool) -> void:
	is_used = _is_used


func get_is_used() -> bool:
	return is_used


func set_is_active(_is_active: bool) -> void:
	is_active = _is_active


func get_is_active() -> bool:
	return is_active
