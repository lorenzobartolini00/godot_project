extends Area

class_name Interactable

func _ready():
	if GameEvents.connect("interact", self, "_on_interact") != OK:
		print("failure")


func _on_interact(character: Character, interactable_object):
	if interactable_object == self:
		print(character.name + " has interacted with " + get_parent().name)
