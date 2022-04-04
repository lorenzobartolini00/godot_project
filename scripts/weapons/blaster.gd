extends ProjectileWeapon

class_name Blaster

export(float) onready var recharge_time = 0.5
export(float) onready var relative_threshold = 0.2

var recharge_timer: Timer
var character
var need_charge: bool = false


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
	
		return _ammo_in_mag > threshold
	else:
		return true


func shoot(_character):
	recharge_timer.start()
	
	#Chiamo funzione definita in RayCastWeapon
	.shoot(_character)


func on_recharge_timer_timeout():
	var _ammo: Ammo = self.get_ammo()
	var mag_size: int = self.mag_size
	
	character.ammo_manager.update_ammo("recover", self)
	
	var _ammo_in_mag: int = self.ammo_in_mag
	var threshold: int = mag_size * relative_threshold
	
	if self.ammo_in_mag > threshold:
		need_charge = false
