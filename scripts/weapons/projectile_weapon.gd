extends DotWeapon

class_name ProjectileWeapon

export(PackedScene) var bullet_scene = preload("res://nodes/bullet.tscn")
export(float) var vertical_spawn_offset:= 0.35


func shoot(character) -> void:
	var bullet: Bullet = bullet_scene.instance()
	var bullet_spawn_position: Vector3 = get_bullet_spawn_position()
	
	var shooting_raycast = character.get_shooting_raycast()
	shooting_raycast.cast_to = Vector3(0, 0, -self.max_distance)
	
	character.get_weapon_position().add_child(bullet)
	
	bullet.initialize(bullet_spawn_position, character)


func get_bullet_spawn_position() -> Vector3:
	var weapon_mesh: Mesh = self.get_mesh()
	var bullet_mesh: Mesh = self.get_ammo().get_mesh()
	
	var weapon_aabb: AABB = weapon_mesh.get_aabb()
	var bullet_aabb: AABB = bullet_mesh.get_aabb()
	
	var muzzle_position: Vector3 = weapon_aabb.end - Vector3(weapon_aabb.size.x/2, weapon_aabb.size.y*vertical_spawn_offset , weapon_aabb.size.z) 
	var bullet_dimension: Vector3 = Vector3(0,0, bullet_aabb.size.z)
	
	return muzzle_position - bullet_dimension/2
