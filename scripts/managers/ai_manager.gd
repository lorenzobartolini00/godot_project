extends Manager

class_name AIManager

onready var runtime_data = character.get_runtime_data() as RuntimeData

var target
var last_seen_position: Vector3
var target_timer: Timer

var path: PoolVector3Array = []

var update_path_timer: Timer
var close_character_list: Array = []

func _ready():
	set_aim_target_timer()
	set_update_path_timer()
	
	GameEvents.connect("target_changed", self, "_on_target_changed")
	GameEvents.connect("character_shot", self, "_on_character_shot")
	target_timer.connect("timeout", self, "_on_target_timer_timeout")
	update_path_timer.connect("timeout", self, "_on_update_path_timer_timeout")
	change_state(Enums.AIState.IDLE)
	
	call_deferred("set_view_distance")
	call_deferred("set_min_distance")


func _physics_process(delta):
	if character.get_is_alive():
		if target and is_instance_valid(target):
			
			character.get_line_of_sight_raycast().set_as_toplevel(true)
			character.get_line_of_sight_raycast().look_at(target.translation, Vector3.UP)
			character.get_line_of_sight_raycast().set_as_toplevel(false)
			
			if is_target_in_direct_sight():
				target_timer.start()
				update_last_seen_position()
				
				if is_target_in_shoot_range() and is_weapon_sight_free():
					brake(delta)
					
					if is_target_aquired():
						change_state(Enums.AIState.TARGET_AQUIRED)
					else:
						change_state(Enums.AIState.AIMING)
					
					if path.size() > 0:
						path = []
				elif not is_target_too_close():
					if has_reach_last_seen_position():
						update_last_seen_position()
					
					change_state(Enums.AIState.APPROACHING)

					move(delta)
				
				aim(delta)
				
			elif not is_target_too_close():
				if not has_reach_last_seen_position():
					change_state(Enums.AIState.SEARCHING)
					
					move(delta)
			
			keep_distance(delta)
		


func move(delta) -> void:
	if path.size() == 0:
		update_navigation_path(last_seen_position)
	
	var navigation: Navigation = character.get_navigation()
	path = navigation.navigate(character, path, delta)


func aim(delta) -> void:
	var turning_speed: float = character.get_statistics().turning_speed
	var upper_part: Spatial = character.get_upper_part()
	
	upper_part.set_as_toplevel(true)
	upper_part.transform = character.smooth_look_at(upper_part, target.transform.origin, turning_speed, delta)
	upper_part.set_as_toplevel(false)


func keep_distance(delta) -> void:
	if close_character_list.size() > 0:
		var direction: Vector3 = Vector3()
#		var velocity: Vector3 = character.velocity
		var speed: float = self.character.get_statistics().move_speed
		var accel: float = self.character.get_statistics().keep_distance_accel
		var force_sum: Vector3
		
		for _character in close_character_list:
			if is_instance_valid(character):
				var force_component: Vector3 = (self.character.translation - _character.translation)
				force_sum += force_component
		
		direction = force_sum.normalized()
		direction.y = 0
		
		character.set_velocity(direction*speed, accel, delta)
		
#		character.velocity = character.velocity.linear_interpolate(direction*speed, delta * accel)
#		self.character.velocity = self.character.move_and_slide(velocity, Vector3.UP)


func brake(delta) -> void:
	var accel: float = self.character.get_statistics().brake_accel
	var new_velocity: Vector3
	
	if character.is_on_floor():
		new_velocity = Vector3(0, -0.1, 0)
	else:
		new_velocity = Vector3(0, character.velocity.y, 0)
	
	character.set_velocity(new_velocity, accel, delta)


func has_reach_last_seen_position() -> bool:
	var distance: float = (last_seen_position - character.translation).length()
	var tollerance: float = character.get_statistics().max_distance_tollerance
	
	return distance < tollerance


func is_target_in_direct_sight() -> bool:
	var collider = character.get_line_of_sight_raycast().get_collider()
	var weapon_collider = character.get_weapon_line_of_sight_raycast().get_collider()
	
	if collider:
		if collider == target:
			return true
	
	return false


func is_weapon_sight_free() -> bool:
	var weapon_collider = character.get_weapon_line_of_sight_raycast().get_collider()
	
	if weapon_collider:
		if weapon_collider == target:
			return true
	else:
		return true
	
	return false


func is_target_in_shoot_range() -> bool:
	var distance: float = (target.translation - character.translation).length()
	var weapon_range: float = character.get_current_weapon().max_distance
	
	return distance <= weapon_range


func is_target_aquired() -> bool:
	var shooting_raycast: RayCast = character.get_shooting_raycast()
	var collider = shooting_raycast.get_collider()
	
	if collider:
		if collider is Shootable:
			return collider.character == target
		else:
			return false
	else:
		return false


func is_target_too_close() -> bool:
	var target_position: Vector3 = target.translation
	var distance: float = (target_position - self.character.translation).length()
	var min_distance: float = self.character.get_statistics().min_distance
	
	return distance < min_distance


func update_last_seen_position():
	if target:
		last_seen_position = target.translation


func update_navigation_path(target: Vector3) -> void:
	if target:
		var navigation: Navigation = character.get_navigation()
		path = navigation.get_points(character, target)
	else:
		path = []


func change_state(new_state: int) -> void:
	var current_state: int = runtime_data.current_ai_state
	
	if current_state != new_state:
		runtime_data.current_ai_state = new_state
		GameEvents.emit_signal("state_changed", character, new_state)


func set_view_distance():
	var max_view_distance: int = character.get_statistics().max_view_distance
	var max_alert_distance: int = character.get_statistics().max_alert_distance

	character.get_view_area().get_child(0).shape.radius = max_alert_distance
	character.get_line_of_sight_raycast().cast_to = Vector3(0, 0, -max_view_distance)


func set_min_distance():
	var min_distance: int = character.get_statistics().min_distance

	character.get_min_distance_area().get_child(0).shape.radius = min_distance


func set_aim_target_timer():
	target_timer = Timer.new()
	call_deferred("add_child", target_timer)
	var lost_target_time: float = character.get_statistics().lost_target_time
	
	target_timer.wait_time = lost_target_time
	target_timer.autostart = false
	target_timer.one_shot = true


func set_update_path_timer():
	update_path_timer = Timer.new()
	call_deferred("add_child", update_path_timer)
	
	update_path_timer.wait_time = 2
	update_path_timer.autostart = true
	update_path_timer.one_shot = false


func get_current_ai_state() -> int:
	return runtime_data.current_ai_state


func _on_target_timer_timeout():
	runtime_data.current_ai_state = Enums.AIState.IDLE
	GameEvents.emit_signal("target_changed", null, character)


func _on_update_path_timer_timeout():
	if runtime_data.current_ai_state == Enums.AIState.APPROACHING:
		update_navigation_path(target.translation)
		pass


func _on_character_shot(_character):
	if _character.is_in_group("player"):
		if not target:
			var distance: float = (self.character.translation - _character.translation).length()
			var max_hear_distance: float = self.character.get_statistics().max_hear_distance
			
			if distance < max_hear_distance:
				GameEvents.emit_signal("target_changed", _character, self.character)
		else:
			update_last_seen_position()


func _on_target_changed(_target, _character):
	if _character == character:
		target = _target
		update_last_seen_position()


func _on_ViewArea_body_entered(body):
	if not target:
		if body.is_in_group("player"):
			GameEvents.emit_signal("target_changed", body, character)


func _on_MinDistanceArea_body_entered(body):
	if body != self.character and not (body is StaticBody):
		close_character_list.append(body)


func _on_MinDistanceArea_body_exited(body):
	if body != self.character:
		var index: int = close_character_list.find(body)
		
		if index >= 0:
			close_character_list.remove(index)
