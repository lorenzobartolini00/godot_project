extends Spatial

export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree
export(NodePath) onready var skeleton_ik = get_node(skeleton_ik) as SkeletonIK

export(Array, NodePath) onready var meshes

onready var character = get_parent() as Character

var meshes_to_rotate: Array

func _physics_process(delta):
	var character_transform: Transform = character.transform
	var character_velocity: Vector3 = character.get_velocity()
	
	var is_character_active: bool = character.get_is_active()
	var is_character_current_controller: bool = character.get_is_current_controller()
	
	var is_model_active: bool = is_character_active or is_character_current_controller
	
	var is_jumping: bool = character.get_is_jumping()
	
	if is_character_active and not is_character_current_controller:
		skeleton_ik.start()
	else:
		skeleton_ik.stop()
	
	animation_tree.set("parameters/conditions/active", is_model_active)
	animation_tree.set("parameters/conditions/deactive", not is_model_active)
	
	animation_tree.set("parameters/conditions/jump", is_jumping)
	
	if is_model_active:
		set_walk_animation(character_transform, character_velocity, delta)


func _ready():
	skeleton_ik.start(false)
	
	for mesh in meshes:
		mesh = get_node(mesh)
		meshes_to_rotate.append(mesh)



func get_root_motion_transform() -> Transform:
	return animation_tree.get_root_motion_transform()


func set_walk_animation(transform: Transform, velocity: Vector3, delta) -> void:
	var blend_position: float
	var xz_velocity: Vector3
	var reverse_factor: int
	
	xz_velocity = velocity
	xz_velocity.y = 0
	
	reverse_factor = 1 if transform.basis.z.dot(xz_velocity) > 0 else -1
	
	for mesh in meshes_to_rotate:
		rotate_mesh(mesh, xz_velocity, reverse_factor, delta)
	
	blend_position = clamp(reverse_factor * xz_velocity.length(), -1, 1)
	
	animation_tree.set("parameters/FreeWalk/blend_position", blend_position)


func rotate_mesh(mesh: MeshInstance, xz_velocity: Vector3, reverse_factor: int, delta: float) -> void:
	var vector1: Vector3
	var look_at_target: Vector3
	
	var speed: float = character.get_statistics().turning_speed
	
	if xz_velocity.length() > 0.1:
		vector1 = -reverse_factor*xz_velocity
		
		look_at_target = vector1.normalized() + mesh.global_transform.origin
	
		look_at_target.y = mesh.global_transform.origin.y
	
		mesh.set_as_toplevel(true)
		mesh.transform = character.smooth_look_at(mesh, look_at_target, speed, delta)
		mesh.set_as_toplevel(false)
	
#	label.text = String("look at: " + str(look_at_target) + " velocity: " + str(xz_velocity) + " front: " + str(mesh.global_transform.origin))
