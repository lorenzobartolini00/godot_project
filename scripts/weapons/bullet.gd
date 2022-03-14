extends RigidBody

class_name Bullet

export(NodePath) onready var mesh_instance = get_node(mesh_instance) as MeshInstance
export(NodePath) onready var despawn_timer = get_node(despawn_timer) as Timer

var _weapon
var _character

var target_point: Vector3

func initialize(start_position: Vector3, character):
	_weapon = character.get_current_weapon()
	_character = character
	
	mesh_instance.mesh = _weapon.get_ammo().get_mesh()
	self.transform.origin = start_position
	
	setup_despawn_timer()
	
	set_as_toplevel(true)


func _physics_process(delta):
	if _weapon:
		
		var direction: Vector3 = -transform.basis.z.normalized()
		linear_velocity = direction * _weapon.get_ammo().bullet_speed


func setup_despawn_timer() -> void:
	despawn_timer.wait_time = _weapon.get_ammo().bullet_life_time
	despawn_timer.autostart = false
	despawn_timer.one_shot = true
	
	despawn_timer.start()


func _on_DespawnTimer_timeout():
	queue_free()


func _on_CollisionArea_area_entered(area):
	if area is Shootable:
		GameEvents.emit_signal("hit", area, _weapon.damage)
	
	queue_free()


func _on_CollisionArea_body_entered(body):
	if body.is_in_group("player"):
		pass
	elif body is StaticBody:
		self.visible = false
		
		
		despawn_timer.start()
