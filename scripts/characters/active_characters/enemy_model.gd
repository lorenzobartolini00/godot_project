extends Spatial

export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree



func get_root_motion_transform() -> Transform:
	return animation_tree.get_root_motion_transform()


func set_walk_animation(blend_amount: float) -> void:
	animation_tree.set("parameters/walking/blend_amount", blend_amount)
