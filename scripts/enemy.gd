extends Character

class_name Enemy

export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager


func _ready():
	pass

func _physics_process(delta):
	_movement()
	
#	if shoot_manager.can_shoot():
#		shoot_manager.shoot(shooting_raycast)
#	elif reload_manager.need_reload() and reload_manager.can_reload():
#		reload_manager.reload()
		


#Override
func _on_died(character) -> void:
	if character == self:
		print(name + " died")
		#Something
		queue_free()

	
func _movement() -> void:
	pass

