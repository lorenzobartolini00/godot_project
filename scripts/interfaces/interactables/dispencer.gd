extends Interactable

class_name Dispencer

export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(Resource) onready var item = item as Item
export(int) onready var quantity
export(NodePath) onready var mesh_reference = get_node(mesh_reference) as MeshInstance
export(float) onready var rotate_speed

func _ready():
	update_display_mesh()


func _process(delta):
	mesh_reference.rotate_object_local(Vector3.UP, rotate_speed * delta)


func _on_interact(character: Character, interactable_object):
	if not is_used:
		if interactable_object == self:
			GameEvents.emit_signal("add_item_to_inventory", character, item, quantity)
			
			animation_player.play("open")
			
			is_used = true
			
			update_display_mesh()


func update_display_mesh():
	mesh_reference.mesh = item.display_mesh
	mesh_reference.visible = not self.is_used
