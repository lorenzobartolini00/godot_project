extends DotWeapon

class_name ProjectileWeapon

export(PackedScene) var bullet_scene = preload("res://nodes/bullet.tscn")
export(float) var bullet_time
export(float) var vertical_spawn_offset:= 0.3


func shoot(character) -> void:
	var bullet: Bullet = bullet_scene.instance()
	var bullet_spawn_position: Vector3 = get_bullet_spawn_position()

	character.get_weapon_position().add_child(bullet)
	
	bullet.initialize(bullet_spawn_position, self.get_ammo().get_mesh())


func get_bullet_spawn_position() -> Vector3:
	var mesh: Mesh = self.mesh
	var aabb: AABB = mesh.get_aabb()
	var muzzle_position: Vector3 = aabb.end - Vector3(aabb.size.x/2, aabb.size.y*vertical_spawn_offset , aabb.size.z) 
	var bullet_dimension: Vector3 = Vector3(0,0, self.get_ammo().get_mesh().get_aabb().size.z)
	return muzzle_position - bullet_dimension/2
