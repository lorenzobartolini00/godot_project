extends RigidBody

class_name Bullet

export(NodePath) onready var mesh_instance = get_node(mesh_instance) as MeshInstance

var _weapon

func initialize(start_position: Vector3, weapon):
	_weapon = weapon
	mesh_instance.mesh = weapon.get_ammo().get_mesh()
	self.transform.origin = start_position
	
	set_as_toplevel(true)


func _physics_process(delta):
	if _weapon:
		var direction: Vector3 = -transform.basis.z.normalized()
		linear_velocity = direction * _weapon.get_ammo().bullet_speed
