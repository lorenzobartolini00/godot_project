tool
extends Area

class_name Collectable

export(Resource) var item = item as Item
export(int) var quantity

onready var _set: bool = false

func _process(delta):
	if not _set:
		_set = true
		get_node("MeshInstance").mesh = item.mesh
	
	

func _physics_process(delta):
	if not Engine.editor_hint:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body is Player:
				GameEvents.emit_signal("collected", get_item(), get_quantity(), body)
				print(item.name + " collected")
				queue_free()
	
	get_node("MeshInstance").rotation_degrees.y += 180*delta


func get_item() -> Item:
	return item


func get_quantity() -> int:
	return quantity
