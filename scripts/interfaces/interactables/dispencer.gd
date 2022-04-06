extends Interactable

class_name Dispencer

export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(Resource) onready var item = item as Item
export(int) onready var quantity
export(bool) onready var used = false


func _ready():
	setup_display_mesh()


func _on_interact(character: Character, interactable_object):
	if not used:
		if interactable_object == self:
			GameEvents.emit_signal("add_item_to_inventory", character, item, quantity)
			
			animation_player.play("open")
			
			used = true


func setup_display_mesh():
	pass
