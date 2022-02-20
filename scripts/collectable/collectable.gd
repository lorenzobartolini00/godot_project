extends Area

class_name Collectable

export(Resource) var item = item as Item
export(int) var quantity


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			GameEvents.emit_signal("collected", get_item(), get_quantity())
			print(item.name + " collected")
			queue_free()


func get_item() -> Item:
	return item


func get_quantity() -> int:
	return quantity
