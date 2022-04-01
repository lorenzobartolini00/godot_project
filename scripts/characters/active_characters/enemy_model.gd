extends Spatial

export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree
export(NodePath) onready var skeleton_ik = get_node(skeleton_ik) as SkeletonIK

export(Array, NodePath) onready var meshes

export(NodePath) onready var label = get_node(label) as Label

var meshes_to_rotate: Array

func _ready():
	skeleton_ik.start(false)
	
	for mesh in meshes:
		mesh = get_node(mesh)
		meshes_to_rotate.append(mesh)


func get_root_motion_transform() -> Transform:
	return animation_tree.get_root_motion_transform()


func set_walk_animation(transform: Transform, velocity: Vector3) -> void:
	var blend_position: float
	var xz_velocity: Vector3
	var reverse_factor: int
	
	xz_velocity = velocity
	xz_velocity.y = 0
	
	reverse_factor = 1 if transform.basis.z.dot(xz_velocity) > 0 else -1
	
	for mesh in meshes_to_rotate:
		rotate_mesh(mesh, xz_velocity, reverse_factor)
	
	blend_position = clamp(reverse_factor * xz_velocity.length(), -1, 1)
	
	animation_tree.set("parameters/walking/blend_position", blend_position)


func rotate_mesh(mesh: MeshInstance, xz_velocity: Vector3, reverse_factor: int) -> void:
	var vector1: Vector3
	var look_at_target: Vector3
	
	if xz_velocity.length() > 0.1:
		vector1 = -reverse_factor*xz_velocity
		
		look_at_target = vector1.normalized() + mesh.global_transform.origin
	
		look_at_target.y = mesh.global_transform.origin.y
	
		mesh.set_as_toplevel(true)
		mesh.look_at(look_at_target, Vector3.UP)
		mesh.set_as_toplevel(false)
	
	label.text = String("look at: " + str(look_at_target) + " velocity: " + str(xz_velocity) + " front: " + str(mesh.global_transform.origin))
