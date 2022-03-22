extends ProjectileWeapon

class_name Blaster

export(float) onready var recharge_time = 0.5
export(float) onready var relative_threshold = 0.2

var recharge_timer: Timer
var character
var need_charge: bool = false


func connect_signal(_character):
	if not GameEvents.is_connected("current_weapon_changed", self, "_on_current_weapon_changed") and not GameEvents.is_connected("current_ammo_changed", self, "_on_current_ammo_changed"):
		character = _character
		GameEvents.connect("current_ammo_changed", self, "_on_current_ammo_changed")
		GameEvents.connect("current_weapon_changed", self, "_on_current_weapon_changed")


func set_up_recharge_timer(character) -> void:
	if not recharge_timer:
		recharge_timer = Timer.new()
		recharge_timer.wait_time = recharge_time
		recharge_timer.one_shot = false
		recharge_timer.autostart = false
		
		recharge_timer.connect("timeout", self, "on_recharge_timer_timeout")
	
		character.add_child(recharge_timer)


func _on_current_weapon_changed(_new_weapon: Weapon, _character):
	if character == _character:
		if _new_weapon == self:
			self.character = _character
			set_up_recharge_timer(_character)
		
			recharge_timer.start()
#		else:
#			recharge_timer.stop()


func _on_current_ammo_changed(_weapon: Weapon, _ammo: Ammo, _character):
	if character == _character:
		if _weapon == self:
			if self.current_ammo == 0:
				need_charge = true


func is_charged() -> bool:
	if need_charge:
		var _ammo: Ammo = self.ammo
		var _current_ammo: int = self.current_ammo
		var _max_ammo: int = _ammo.max_ammo
		var threshold: int = _max_ammo * relative_threshold
	
		return _current_ammo > threshold
	else:
		return true


func shoot(character):
	recharge_timer.start()
	
	#Chiamo funzione definita in RayCastWeapon
	.shoot(character)


func on_recharge_timer_timeout():
	var _ammo: Ammo = self.get_ammo()
	var _max_ammo: int = _ammo.max_ammo
	var _ammo_per_shot: int = _ammo.ammo_per_shot
	
	self.current_ammo = clamp(self.current_ammo + _ammo_per_shot, 0, _max_ammo)
	GameEvents.emit_signal("current_ammo_changed", self, _ammo, character)
	
	var _current_ammo: int = self.current_ammo
	var threshold: int = _max_ammo * relative_threshold
	
	if self.current_ammo > threshold:
		need_charge = false
