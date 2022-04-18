extends Area

class_name Interactable

var is_used: bool setget set_is_used, get_is_used


func _ready():
	if GameEvents.connect("interact", self, "_on_interact") != OK:
		print("failure")


func _on_interact(character: Character, interactable_object):
	if interactable_object == self:
		print(character.name + " has interacted with " + get_parent().name)


func set_is_used(_is_used: bool) -> void:
	is_used = _is_used


func get_is_used() -> bool:
	return is_used
