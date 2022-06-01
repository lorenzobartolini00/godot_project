extends Weapon

class_name DotWeapon


export(int) var ammo_in_mag = mag_size
export(int) var mag_size
export(int) var ammo_consume
export(int) var ammo_recover
export(float) var reload_time
export(float) var shoot_time
export(bool) var is_shoot_timer_timeout = true
export(float) var max_distance:= 20.0
export(float) var vertical_spawn_offset:= 0.35
export(bool) var is_auto_rechargable
export(float) var recharge_time = 0.5
export(float)  var relative_threshold = 0.0


var recharge_timer: Timer
var character
var need_charge: bool = false

#Da ridefinire nelle sottoclassi
func shoot(_character):
	if is_auto_rechargable:
		recharge_timer.start()
	
	add_muzzle_flash(_character)


func is_fully_loaded() -> bool:
	return ammo_in_mag == mag_size


func connect_signal(_character):
	if not GameEvents.is_connected("current_weapon_changed", self, "_on_current_weapon_changed") and not GameEvents.is_connected("ammo_changed", self, "_on_ammo_changed"):
		character = _character
		if GameEvents.connect("ammo_changed", self, "_on_ammo_changed") != OK:
			print("failure")
		if GameEvents.connect("current_weapon_changed", self, "_on_current_weapon_changed") != OK:
			print("failure")


func set_up_recharge_timer(_character) -> void:
	if not recharge_timer:
		recharge_timer = Timer.new()
		recharge_timer.wait_time = recharge_time
		recharge_timer.one_shot = false
		recharge_timer.autostart = false
		
		if recharge_timer.connect("timeout", self, "on_recharge_timer_timeout") != OK:
			print("failure")
	
		_character.add_child(recharge_timer)


func _on_current_weapon_changed(_new_weapon: Weapon, _character):
	if character == _character:
		if _new_weapon == self:
			if is_auto_rechargable:
				self.character = _character
				set_up_recharge_timer(_character)
			
				recharge_timer.start()


func _on_ammo_changed(_weapon: Weapon, _character):
	if character == _character:
		if _weapon == self:
			if self.ammo_in_mag == 0:
				need_charge = true


func is_charged() -> bool:
	if need_charge:
		var _ammo_in_mag: int = self.ammo_in_mag
		var mag_size: int = self.mag_size
		var threshold: int = mag_size * relative_threshold
	
		return _ammo_in_mag >= threshold
	else:
		return true


func on_recharge_timer_timeout():
	var _ammo: Ammo = self.get_ammo()
	var mag_size: int = self.mag_size
	
	character.ammo_manager.update_ammo("recover", self)
	
	var _ammo_in_mag: int = self.ammo_in_mag
	var threshold: int = mag_size * relative_threshold
	
	if self.ammo_in_mag > threshold:
		need_charge = false


func get_target_type(aim_raycast: RayCast) -> int:
	var collider = aim_raycast.get_collider()
	
	if collider:
		if collider is Shootable:
			return Enums.TargetTipology.SHOOTABLE
		
	return Enums.TargetTipology.NO_TARGET


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


func delete_muzzle(_character) -> void:
	var weapon_position: Spatial = _character.get_weapon_position()
	var muzzle: Spatial

	var children: Array = weapon_position.get_children()
	for child in children:
		if child.name == "MuzzleFlash":
			muzzle = child

	if muzzle:
		muzzle.queue_free()
