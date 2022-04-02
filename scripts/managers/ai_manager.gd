extends Manager

class_name AIManager

onready var runtime_data = character.get_runtime_data() as RuntimeData

var target
var last_seen_position: Vector3
var lost_target_timer: Timer

var path: PoolVector3Array = []

var update_path_timer: Timer
var update_random_path_timer: Timer
var close_character_list: Array = []

var never_reached_last_seen_position: bool = true

var wait_to_shoot_timer: Timer
var can_shoot: bool = true


func _ready():
	setup_all_timers() 
	
	GameEvents.connect("target_changed", self, "_on_target_changed")
	GameEvents.connect("character_shot", self, "_on_character_shot")
	
	lost_target_timer.connect("timeout", self, "_on_target_timer_timeout")
	update_path_timer.connect("timeout", self, "_on_update_path_timer_timeout")
	update_random_path_timer.connect("timeout", self, "_on_update_random_path_timer_timeout")
	wait_to_shoot_timer.connect("timeout", self, "_on_wait_to_shoot_timer_timeout")
	
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
				lost_target_timer.start()
				never_reached_last_seen_position = true
				update_last_seen_position()
				
				if is_target_in_shoot_range() and is_weapon_sight_free():
					brake(delta)
					
					if is_target_aquired():
						if can_shoot:
							change_state(Enums.AIState.TARGET_AQUIRED)
						else:
							change_state(Enums.AIState.WAITING)
					else:
						change_state(Enums.AIState.AIMING)
					
					if not is_target_too_close():
						follow_path(delta)
					else:
						var small_random_point_radius: float = character.get_statistics().small_random_point_radius
						update_path_to_random(target.translation, small_random_point_radius, true)
					
				elif not is_target_too_close():
					change_state(Enums.AIState.APPROACHING)
					
					move_toward_target(delta)
				
				aim(delta)
				
			else:
				change_state(Enums.AIState.SEARCHING)
				
				if never_reached_last_seen_position:
					if not has_reached_last_seen_position():
						move_toward_target(delta)
					else:
						never_reached_last_seen_position = false
				
				elif not never_reached_last_seen_position:
					var big_random_point_radius: float = character.get_statistics().big_random_point_radius
					move_to_random_position(last_seen_position, big_random_point_radius, delta)
			
			keep_distance(delta)
		else:
			change_state(Enums.AIState.IDLE)
			
			keep_distance(delta)
			
			var idle_point_radius: float = character.get_statistics().idle_point_radius
			move_to_random_position(character.translation, idle_point_radius, delta)


func move_toward_target(delta, override: bool = false) -> void:
	update_path_to_target(override)
	
	follow_path(delta)


func follow_path(delta) -> void:
	var navigation: Navigation = character.get_navigation()
	path = navigation.navigate(character, path, delta)


func aim(delta) -> void:
	var turning_speed: float = character.get_statistics().turning_speed
	var upper_part: Spatial = character.get_upper_part()
	
	upper_part.set_as_toplevel(true)
	upper_part.transform = character.smooth_look_at(upper_part, target.global_transform.origin, turning_speed, delta)
	upper_part.set_as_toplevel(false)


func move_to_random_position(initial_position: Vector3, radius: float, delta) -> void:
	update_path_to_random(initial_position, radius)
	
	follow_path(delta)


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


func brake(delta) -> void:
	var accel: float = self.character.get_statistics().brake_accel
	var new_velocity: Vector3
	
	if character.is_on_floor():
		new_velocity = Vector3(0, -0.1, 0)
	else:
		new_velocity = Vector3(0, character.velocity.y, 0)
	
	character.set_velocity(new_velocity, accel, delta)


func has_reached_last_seen_position() -> bool:
	var distance: Vector3 = last_seen_position - character.translation
	distance.y = 0
	var horizontal_distance = distance.length()
	
	var tollerance: float = character.get_statistics().max_distance_tollerance
	
	return horizontal_distance < tollerance


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


func update_path_to_target(override: bool = false) -> void:
	if override or path.size() == 0:
		set_path(last_seen_position)


func update_path_to_random(initial_position: Vector3, radius: float, override: bool = false) -> void:
	if override or path.size() == 0:
		var min_distance: float = character.get_statistics().min_distance
		
		Util.rng.randomize()
		var random_position = initial_position + Vector3(Util.rng.randf_range(-radius, radius), 0, Util.rng.randf_range(-radius, radius)) 
		
		if random_position.distance_to(initial_position) < min_distance:
			var buffer: Vector3 = (random_position - initial_position).normalized() * min_distance
			random_position += buffer
		
		set_path(random_position)


func set_path(target: Vector3) -> void:
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


func setup_all_timers():
	var update_path_time: float = character.get_statistics().update_path_time
	var update_random_path_time: float = character.get_statistics().update_random_path_time
	var lost_target_time: float = character.get_statistics().lost_target_time
	var wait_to_shoot_time: float = character.get_statistics().wait_to_shoot_time
	
	
	lost_target_timer = Util.setup_timer(lost_target_timer, self, lost_target_time, false, true)
	update_path_timer = Util.setup_timer(update_path_timer, self, update_path_time)
	update_random_path_timer = Util.setup_timer(update_random_path_timer, self, update_path_time)
	wait_to_shoot_timer = Util.setup_timer(wait_to_shoot_timer, self, wait_to_shoot_time)


func get_current_ai_state() -> int:
	return runtime_data.current_ai_state


func _on_target_timer_timeout():
	runtime_data.current_ai_state = Enums.AIState.IDLE
	GameEvents.emit_signal("target_changed", null, character)


func _on_update_path_timer_timeout():
	if runtime_data.current_ai_state == Enums.AIState.APPROACHING:
		update_path_to_target(true)


func _on_update_random_path_timer_timeout():
	if runtime_data.current_ai_state == Enums.AIState.AIMING\
	or runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED:
		var small_random_point_radius: float = character.get_statistics().small_random_point_radius
		 
		update_path_to_random(target.translation, small_random_point_radius, true)


func _on_wait_to_shoot_timer_timeout():
	if runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED\
	or runtime_data.current_ai_state == Enums.AIState.WAITING\
	or runtime_data.current_ai_state == Enums.AIState.AIMING:
		can_shoot = not can_shoot
	else:
		can_shoot = true


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
		
		path = []
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
