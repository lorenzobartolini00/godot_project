extends RigidBody

class_name Bullet


func _ready():
	print("bullet ready")
	get_tree().add_child(self)
