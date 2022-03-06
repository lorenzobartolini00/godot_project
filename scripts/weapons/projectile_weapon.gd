extends DotWeapon

class_name ProjectileWeapon

export(PackedScene) var instance_bullet = preload("res://nodes/bullet.tscn")
export(float) var bullet_time


func shoot(shooting_raycast: RayCast) -> void:
	var bullet: Bullet = instance_bullet.instance()
#	add_child(bullet)
	
	bullet.set_as_toplevel(true)
