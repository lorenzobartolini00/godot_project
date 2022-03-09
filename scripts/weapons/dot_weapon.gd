extends Weapon

class_name DotWeapon

export(float) var reload_time
export(float) var shoot_time
export(bool) var is_shoot_timer_timeout = true
export(float) var max_distance:= 20
export(float) var vertical_spawn_offset:= 0.35

var muzzle

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
	
#	var already_here: bool = true
#	var muzzle: Spatial
#
#	var children: Array = weapon_position.get_children()
#	for child in children:
#		if child.name == "MuzzleFlash":
#			muzzle = child
#
#	if not muzzle:
#		muzzle = self.muzzle_flash.instance()
#
#		weapon_position.add_child(muzzle)
#		muzzle.translation = self.get_muzzle_position()
#		muzzle.name = "MuzzleFlash"
#
#	self.muzzle = muzzle
#
#	muzzle.visible = true


func delete_muzzle(character) -> void:
	var weapon_position: Spatial = character.get_weapon_position()
	var muzzle: Spatial

	var children: Array = weapon_position.get_children()
	for child in children:
		if child.name == "MuzzleFlash":
			muzzle = child

	if muzzle:
		muzzle.queue_free()
