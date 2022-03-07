extends Weapon

class_name DotWeapon

export(float) var reload_time
export(float) var shoot_time
export(bool) var is_shoot_timer_timeout = true
export(float) var max_distance:= 20
export(float) var vertical_spawn_offset:= 0.35


func get_muzzle_position() -> Vector3:
	var weapon_mesh: Mesh = self.get_mesh()
	
	var weapon_aabb: AABB = weapon_mesh.get_aabb()
	
	var muzzle_position: Vector3 = weapon_aabb.end - Vector3(weapon_aabb.size.x/2, weapon_aabb.size.y*vertical_spawn_offset , weapon_aabb.size.z) 
	
	return muzzle_position
