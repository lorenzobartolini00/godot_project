extends Weapon

class_name DotWeapon


export(int) var ammo_in_mag = mag_size
export(int) var mag_size
export(int) var ammo_per_shot
export(float) var reload_time
export(float) var shoot_time
export(bool) var is_shoot_timer_timeout = true
export(float) var max_distance:= 20
export(float) var vertical_spawn_offset:= 0.35


func is_fully_loaded() -> bool:
	return ammo_in_mag == mag_size


func get_muzzle_position() -> Vector3:
	var weapon_mesh: Mesh = self.get_mesh()
	
	var weapon_aabb: AABB = weapon_mesh.get_aabb()
	
	var muzzle_position: Vector3 = weapon_aabb.end - Vector3(weapon_aabb.size.x/2, weapon_aabb.size.y*vertical_spawn_offset , weapon_aabb.size.z) 
	
	return muzzle_position


func add_muzzle_flash(character) -> void:
	var weapon_position: Spatial = character.get_weapon_position()
	var muzzle = self.muzzle_flash.instance()
	
	weapon_position.add_child(muzzle)
	muzzle.translation = self.get_muzzle_position()
	muzzle.name = "MuzzleFlash"


func delete_muzzle(character) -> void:
	var weapon_position: Spatial = character.get_weapon_position()
	var muzzle: Spatial

	var children: Array = weapon_position.get_children()
	for child in children:
		if child.name == "MuzzleFlash":
			muzzle = child

	if muzzle:
		muzzle.queue_free()
