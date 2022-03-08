extends BasicFirstPersonController

class_name Player


export(NodePath) onready var inventory_manager = get_node(inventory_manager) as InventoryManager
export(NodePath) onready var camera = get_node(camera) as Camera

export(Resource) var inventory = inventory as Inventory

onready var _life_slot = preload("res://my_resources/life_statistics/life_slot.tres") as LifeSlot

func _ready() -> void:
	self._move_speed = statistics.move_speed
	
	GameEvents.emit_signal("add_item_to_inventory", get_current_weapon(), 1)
	GameEvents.emit_signal("add_item_to_inventory", get_current_weapon().get_ammo(), 0)
	
	GameEvents.emit_signal("change_current_life", 0, false, self)
	GameEvents.emit_signal("change_current_weapon", get_current_weapon(), self)


func _physics_process(delta):
	movement(delta)
	
	if Input.is_action_pressed("shoot"):
		shoot_manager.shoot(delta)
	elif Input.is_action_just_pressed("reload"):
		reload_manager.reload()
	
	if Input.is_action_just_pressed("change_weapon"):
		weapon_manager.shift_current_weapon(1)


func _input(event) -> void:
	aim(event)
	
	if Input.is_action_just_pressed("show_inventory"):
		inventory.show_inventory()
		print(get_life().get_current_life())


func get_inventory() -> Inventory:
	return inventory


func get_camera() -> Camera:
	return camera


func _on_CollectingArea_area_entered(area):
	if area is Collectable:
			GameEvents.emit_signal("collected", area, area.get_item(), area.get_quantity(), self)
			print(area.get_item().name + " collected")
