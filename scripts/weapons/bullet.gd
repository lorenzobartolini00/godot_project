extends RigidBody

class_name Bullet

export(NodePath) onready var mesh_instance = get_node(mesh_instance) as MeshInstance


func initialize(start_position: Vector3, bullet_mesh: Mesh):
	mesh_instance.mesh = bullet_mesh
	self.transform.origin = start_position
	
	set_as_toplevel(true)
