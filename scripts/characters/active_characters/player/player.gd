extends BasicFirstPersonController

class_name Player

export(Resource) var global_runtime_data = global_runtime_data as RuntimeData

export(NodePath) onready var interaction_raycast = get_node(interaction_raycast) as RayCast
export(NodePath) onready var inventory_manager = get_node(inventory_manager) as InventoryManager


export(Resource) var inventory = inventory as Inventory

onready var _life_slot = preload("res://my_resources/life_statistics/life_slot.tres") as LifeSlot


func _ready() -> void:
	GameEvents.emit_signal("add_item_to_inventory",self, get_current_weapon(), 1)
	GameEvents.emit_signal("add_item_to_inventory",self, get_current_weapon().get_ammo(), 0)
	
	#Da sostituire quando verrà implementato il salvataggio
	self.get_inventory().set_item_quantity(_life_slot, 1)
	
	GameEvents.emit_signal("change_current_life", 0, true, self)
	GameEvents.emit_signal("change_current_weapon", get_current_weapon(), self)


func _input(event) -> void:
	if is_current_controller:
		if Input.is_action_just_pressed("show_inventory"):
			get_inventory().show_inventory()


#Override
func player_behaviour(delta):
	if global_runtime_data.current_gameplay_state == Enums.GamePlayState.PLAY:
		.player_behaviour(delta)
		
		if Input.is_action_just_pressed("change_weapon"):
			weapon_manager.shift_current_weapon(1)
		
		if Input.is_action_just_pressed("interact"):
			check_interaction()


#Override
func bot_behaviour(delta):
	pass


#Override
func _on_died(character) -> void:
	if character == self:
		character.set_is_alive(false)
		print(name + " died")
		
		set_damage_area_off()


func set_inventory(_inventory: Inventory) -> void:
	inventory = _inventory


func get_inventory() -> Inventory:
	return inventory


func get_camera() -> Camera:
	return camera


func get_interaction_raycast() -> RayCast:
	return interaction_raycast	


func _on_CollectingArea_area_entered(area):
	if area is Collectable:
			GameEvents.emit_signal("collected", area, area.get_item(), area.get_quantity(), self)
			print(area.get_item().name + " collected")


func check_interaction():
	var collider = interaction_raycast.get_collider()
	
	if collider is Interactable:
		GameEvents.emit_signal("interact", self, collider)
