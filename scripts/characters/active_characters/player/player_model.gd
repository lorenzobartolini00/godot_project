extends Spatial

class_name PlayerModel

export(NodePath) onready var skeleton_ik = get_node(skeleton_ik) as SkeletonIK
export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree
export(NodePath) onready var character = get_node(character) as Player
export(Array, NodePath) onready var meshes

var meshes_to_rotate: Array

func _ready():
	skeleton_ik.start()
	
	if GameEvents.connect("activate_slider", self, "_on_activate_slider") != OK:
		print("failure")
	if GameEvents.connect("stop_sliding", self, "_on_stop_sliding") != OK:
		print("failure")
	if GameEvents.connect("change_controller", self, "_on_controller_changed") != OK:
		print("failure")
	if GameEvents.connect("interact", self, "_on_interact") != OK:
		print("failure")
	for mesh in meshes:
		mesh = get_node(mesh)
		meshes_to_rotate.append(mesh)


func _physics_process(delta):
	var character_transform: Transform = character.transform
	var character_velocity: Vector3 = character.get_velocity()
	
	var is_jumping: bool = character.get_is_jumping()
	
	if is_jumping:
		animation_tree.set("parameters/jump/active", is_jumping)
	
	set_walk_animation(character_transform, character_velocity, delta)


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
	
	animation_tree.set("parameters/run/blend_position", blend_position)


func rotate_mesh(mesh: MeshInstance, xz_velocity: Vector3, reverse_factor: int, delta: float) -> void:
	var vector1: Vector3
	var look_at_target: Vector3
	
	var speed: float = character.get_statistics().turning_speed
	
	if xz_velocity.length() > 0.1:
		vector1 = -reverse_factor*xz_velocity
		
		look_at_target = vector1.normalized() + mesh.global_transform.origin
	
		look_at_target.y = mesh.global_transform.origin.y
	
		mesh.look_at(look_at_target, Vector3.UP)
		#mesh.set_as_toplevel(true)
		#mesh.transform = character.smooth_look_at(mesh, look_at_target, speed, delta)
		#mesh.set_as_toplevel(false)
	
#	label.text = String("look at: " + str(look_at_target) + " velocity: " + str(xz_velocity) + " front: " + str(mesh.global_transform.origin))


func show_mesh(visible: bool = true):
	get_node("bot_rig/Skeleton/Torso").visible = visible
	get_node("bot_rig/Skeleton/Head").visible = visible


func _on_activate_slider(_slider: SlidingRope, _character: Character, active: bool):
	if character == _character:
		if active:
			animation_tree.set("parameters/sliding/blend_amount", 1)
		else:
			animation_tree.set("parameters/sliding/blend_amount", 0)


func _on_controller_changed(new_controller: Character, old_controller: Character):
	if new_controller == character:
		show_mesh(false)
	
	if old_controller == character:
		show_mesh()


func _on_stop_sliding(_character: Character):
	if character == _character:
		animation_tree.set("parameters/sliding/blend_amount", 0)


func _on_interact(_character: Character, _interactable_object):
	if character == _character:
		animation_tree.set("parameters/interact/active", true)
