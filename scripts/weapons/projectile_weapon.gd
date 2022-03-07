extends DotWeapon

class_name ProjectileWeapon

export(PackedScene) var bullet_scene = preload("res://nodes/bullet.tscn")



func shoot(character) -> void:
	var bullet: Bullet = bullet_scene.instance()
	var bullet_spawn_position: Vector3 = get_bullet_spawn_position()
	
	character.get_weapon_position().add_child(bullet)
	
	bullet.initialize(bullet_spawn_position, character)


func get_bullet_spawn_position() -> Vector3:
	var bullet_mesh: Mesh = self.get_ammo().get_mesh()
	var bullet_aabb: AABB = bullet_mesh.get_aabb()
	
	var muzzle_position: Vector3 = get_muzzle_position()
	var bullet_dimension: Vector3 = Vector3(0,0, bullet_aabb.size.z)
	
	return muzzle_position - bullet_dimension/2
