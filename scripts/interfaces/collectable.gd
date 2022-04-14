tool
extends Area

class_name Collectable

export(Resource) var item = item as Item
export(int) var quantity

onready var _set: bool = false

func _ready():
	if GameEvents.connect("collected", self, "_on_collected") != OK:
		print("failure")


func _process(_delta):
	if not _set:
		if item:
			get_node("MeshInstance").mesh = item.display_mesh
			_set = true


func _physics_process(delta):
	
	get_node("MeshInstance").rotation_degrees.y += 180*delta


func _on_collected(area: Collectable, _item: Item, _quantity: int, _character):
	if area == self:
		if _character.is_in_group("player"):
			GameEvents.emit_signal("add_item_to_inventory", _character, _item, _quantity)
		
		queue_free()


func get_item() -> Item:
	return item


func get_quantity() -> int:
	return quantity
