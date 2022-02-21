extends BasicFirstPersonController

class_name Player

export(NodePath) onready var damage_area = get_node(damage_area) as Shootable
export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager
#export(NodePath) onready var weapon_manager = get_node(weapon_manager) as WeaponManager
export(NodePath) onready var ammo_manager = get_node(ammo_manager) as AmmoManager


export(Resource) var inventory = inventory as Inventory

func _ready() -> void:
	self._move_speed = statistics.speed
	
#	GameEvents.connect("collected", self, "_on_collected")
	GameEvents.connect("found_new_item", self, "_on_new_item_found")
	
	GameEvents.emit_signal("collected", self.get_current_weapon(), 1, self)
	GameEvents.emit_signal("life_changed", self.get_life(), self)

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
		GameEvents.emit_signal("show_weapon_list", inventory.get_items()[Enums.ItemTipology.WEAPON])
		inventory.show_inventory()

#Overrride
func _on_collected(_item: Item, _quantity: int, character):
	if character == self:
		inventory.add_item(_item, _quantity)


func _on_new_item_found(_new_item: Item):
	if _new_item is Weapon:
		#Aggiungo nell'inventario lo slot vuoto per le munizioni
		inventory.add_item(_new_item.get_ammo(), 0)
		
		#Seleziono la nuova arma raccolta come quella corrente
		weapon_manager.change_current_weapon(_new_item)


func get_inventory() -> Inventory:
	return inventory
