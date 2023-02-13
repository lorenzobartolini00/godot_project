extends Spatial

class_name Scanner

export(NodePath) onready var door = get_node(door) as Door
export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree
export(NodePath) onready var open_area = get_node(open_area) as Area


func _ready():
	if GameEvents.connect("lock_door", self, "_on_door_locked") != OK:
		print("failure")
	if open_area.connect("body_entered", self, "_on_open_area_body_entered") != OK:
		print("failure")


#Callback invocata quando un personaggio entra nell'area di scansione
func _on_open_area_body_entered(body):
	if not door.get_is_open():
		animation_tree.set("parameters/scanning_process/conditions/scanning", true);


#Callback invocata quando la porta viene sbloccata o bloccata.
func _on_door_locked(_door: Door, is_locked: bool):
	if _door == door:
		animation_tree.set("parameters/scanning_process/conditions/accepted", not is_locked);
		animation_tree.set("parameters/scanning_process/conditions/rejected", is_locked);
