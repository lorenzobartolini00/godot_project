extends PassiveCharacter

class_name DoorTarget

export(NodePath) onready var door = get_node(door) as Door


func _on_died(character):
	._on_died(character)
	
	if character == self:
		GameEvents.emit_signal("unlock_door", door)
