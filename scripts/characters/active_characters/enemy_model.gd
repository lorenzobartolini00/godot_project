extends Spatial

export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree
export(NodePath) onready var skeleton_ik = get_node(skeleton_ik) as SkeletonIK


func _ready():
	skeleton_ik.start(false)


func get_root_motion_transform() -> Transform:
	return animation_tree.get_root_motion_transform()


func set_walk_animation(transform: Transform, velocity: Vector3) -> void:
	var blend_position: float
	
	var xz_velocity: Vector3 = Vector3(velocity.x,0, velocity.z)
	
	blend_position = clamp(transform.basis.z.dot(xz_velocity), -1, 1)
	
	animation_tree.set("parameters/walking/blend_position", blend_position)
	
	
