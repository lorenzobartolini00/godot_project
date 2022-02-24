tool
extends Area

class_name Collectable

export(Resource) var item = item as Item
export(int) var quantity

onready var _set: bool = false

func _ready():
	GameEvents.connect("collected", self, "_on_collected")


func _process(_delta):
	if not _set:
		_set = true
		get_node("MeshInstance").mesh = item.mesh


func _physics_process(delta):
	get_node("MeshInstance").rotation_degrees.y += 180*delta


func _on_collected(area: Collectable, _item: Item, _quantity: int, _character):
	if area == self:
		if _character.is_in_group("player"):
			var inventory: Inventory = _character.get_inventory()
			
			GameEvents.emit_signal("add_item_to_inventory", _item, _quantity)
			
			if _item is Usable:
				_item.use(_character)
		
		queue_free()


func get_item() -> Item:
	return item


func get_quantity() -> int:
	return quantity
