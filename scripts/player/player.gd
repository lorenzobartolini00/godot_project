extends BasicFirstPersonController

class_name Player

export(NodePath) onready var damage_area = get_node(damage_area) as Shootable
export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager
#export(NodePath) onready var weapon_manager = get_node(weapon_manager) as WeaponManager
#export(NodePath) onready var ammo_manager = get_node(ammo_manager) as AmmoManager

export(NodePath) onready var inventory_manager = get_node(inventory_manager) as InventoryManager

export(Resource) var inventory = inventory as Inventory

onready var _life_slot = preload("res://my_resources/life_statistics/life_slot.tres") as LifeSlot

func _ready() -> void:
	self._move_speed = statistics.speed
	
	GameEvents.emit_signal("add_item_to_inventory", get_current_weapon(), 1)
	GameEvents.emit_signal("add_item_to_inventory", get_current_weapon().get_ammo(), 0)
	
	GameEvents.emit_signal("change_current_life", 0, false, self)
	GameEvents.emit_signal("change_current_weapon", get_current_weapon(), self)

func _physics_process(delta):
	movement(delta)
	
	if Input.is_action_pressed("shoot"):
		shoot_manager.shoot(shooting_raycast)
	elif Input.is_action_just_pressed("reload"):
		reload_manager.reload()
#	elif Input.is_action_just_pressed("drop_weapon"):
#		weapon_manager.drop_weapon()
	
	if Input.is_action_just_pressed("change_weapon"):
		weapon_manager.shift_current_weapon(1)
	


func _input(event) -> void:
	aim(event)
	
	if Input.is_action_just_pressed("show_inventory"):
#		GameEvents.emit_signal("show_weapon_list", inventory.get_items()[Enums.ItemTipology.WEAPON])
		inventory.show_inventory()
		GameEvents.emit_signal("current_life_changed", self.get_life(), self)
		print(get_life().get_current_life())


func get_inventory() -> Inventory:
	return inventory


func _on_CollectingArea_area_entered(area):
	if area is Collectable:
			GameEvents.emit_signal("collected", area ,area.get_item(), area.get_quantity(), self)
			print(area.get_item().name + " collected")
