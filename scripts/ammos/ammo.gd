extends Stockable

class_name Ammo


export(Mesh) onready var bullet_mesh


func get_bullet_mesh() -> Mesh:
	return bullet_mesh


func set_bullet_mesh(_bullet_mesh: Mesh) -> void:
	bullet_mesh = _bullet_mesh
