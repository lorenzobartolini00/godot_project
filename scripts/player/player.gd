extends BasicFirstPersonController

class_name Player

export(NodePath) onready var damage_area = get_node(damage_area) as Shootable
export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager
export(NodePath) onready var weapon_manager = get_node(weapon_manager) as WeaponManager
export(NodePath) onready var ammo_manager = get_node(ammo_manager) as AmmoManager


export(Resource) var inventory = inventory as Inventory

func _ready() -> void:
	self._move_speed = statistics.speed
	GameEvents.connect("collected", self, "_on_collected")

func _physics_process(delta):
	movement(delta)


func _input(event) -> void:
	aim(event)
		
	if Input.is_action_just_pressed("shoot"):
		shoot_manager.shoot(shooting_raycast)
	elif Input.is_action_just_pressed("reload"):
		reload_manager.reload()
#	elif Input.is_action_just_pressed("drop_weapon"):
#		weapon_manager.drop_weapon()
	
	if Input.is_action_just_pressed("change_weapon"):
		weapon_manager.change_weapon(1)
		
		
	
	if Input.is_action_just_pressed("show_inventory"):
		inventory.show_inventory()


func _on_collected(_item: Item):
	inventory.add_item(_item)


func get_inventory() -> Inventory:
	return inventory
