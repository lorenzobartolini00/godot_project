extends PassiveCharacter

class_name DoorTarget

export(NodePath) onready var door = get_node(door) as Door


func get_door() -> Door:
	return door
