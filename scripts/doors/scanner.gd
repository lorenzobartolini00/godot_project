extends Spatial

class_name Scanner

export(NodePath) onready var door = get_node(door) as Door
export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree


func _ready():
	if GameEvents.connect("lock_door", self, "_on_door_locked") != OK:
		print("failure")


func _on_OpenArea_body_entered(body):
	if not door.get_is_open():
		animation_tree.set("parameters/scan/active", true);


func _on_door_locked(_door: Door, is_locked: bool):
	if _door == door:
		var amount = 1 if is_locked else -1
		animation_tree.set("parameters/acceptance/add_amount", amount);
