extends Character

class_name Enemy

export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager


func _ready():
	
	GameEvents.emit_signal("collected", self.get_current_weapon(), 1, self)

func _physics_process(delta):
	_movement()
	_aim()
	
	shoot_manager.shoot(shooting_raycast)
	
	if reload_manager.need_reload():
		reload_manager.reload()


func _on_collected(_item: Item, _quantity: int, character):
	if character == self:
		weapon_manager.change_current_weapon(_item)


#Override
func _on_died(character) -> void:
	if character == self:
		print(name + " died")
		#Something
		queue_free()


func _aim() -> void:
	pass


func _movement() -> void:
	pass

