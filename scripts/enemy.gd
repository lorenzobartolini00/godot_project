extends Character

class_name Enemy

export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager
export(NodePath) onready var weapon_position = get_node(weapon_position) as Spatial

func _ready():
	GameEvents.emit_signal("change_current_weapon", self.get_current_weapon(), self)


func _physics_process(_delta):
	_movement()
	_aim()
	
	shoot_manager.shoot()
	
	if reload_manager.need_reload():
		reload_manager.reload()


func get_shooting_raycast() -> RayCast:
	return shooting_raycast


func get_weapon_position() -> Spatial:
	return weapon_position


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

