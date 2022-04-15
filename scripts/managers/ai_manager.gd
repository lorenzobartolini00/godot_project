extends Manager

class_name AIManager

export(float) var player_offset
export(float) var enemy_offset
export(float) var view_offset

var offset: Vector3
var view_offset_vector: Vector3

onready var runtime_data = character.get_runtime_data() as RuntimeData

onready var target: Node = null

onready var last_seen_position: Vector3

onready var wait_to_shoot_timer: Timer
onready var lost_target_timer: Timer
onready var idle_path_timer: Timer

onready var close_character_list: Array = []

onready var can_shoot: bool = true
onready var spawn_position: Vector3


func _ready():
	setup_all_timers() 
	
	offset = Vector3(0, player_offset, 0)
	view_offset_vector = Vector3(0, view_offset, 0)
	
	spawn_position = character.global_transform.origin
	
	if GameEvents.connect("target_changed", self, "_on_target_changed") != OK:
		print("failure")
	if GameEvents.connect("character_shot", self, "_on_character_shot") != OK:
		print("failure")
	if lost_target_timer.connect("timeout", self, "_on_target_timer_timeout") != OK:
		print("failure")
	if wait_to_shoot_timer.connect("timeout", self, "_on_wait_to_shoot_timer_timeout") != OK:
		print("failure")
	if idle_path_timer.connect("timeout", self, "_on_idle_path_timer_timeout") != OK:
		print("failure")
	if GameEvents.connect("change_controller", self, "_on_controller_changed") != OK:
		print("failure")
	if GameEvents.connect("piece_ripped", self, "_on_piece_ripped") != OK:
		print("failure")
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")
	
	change_state(Enums.AIState.START)
	
	call_deferred("set_view_distance")
	call_deferred("set_min_distance")


func ai_movement(delta):
	if character.get_is_alive():
		if target and is_instance_valid(target):
#				if is_life_too_low():
#					character.set_is_able_to_fight(false)
			
			character.get_line_of_sight_raycast().set_as_toplevel(true)
			character.get_line_of_sight_raycast().look_at(view_offset_vector + target.global_transform.origin, Vector3.UP)
			character.get_line_of_sight_raycast().set_as_toplevel(false)
			
			if is_target_in_direct_sight():
				lost_target_timer.start()
				
				update_last_seen_position()
				
				if is_weapon_sight_free() and is_target_in_shoot_range():
					if can_shoot and character.get_is_able_to_shoot():
						if is_target_aquired() or not character.get_is_able_to_aim():
							if not is_state(Enums.AIState.TARGET_AQUIRED):
								wait_to_shoot_timer.start()
								
								change_state(Enums.AIState.TARGET_AQUIRED)
							else:
								#Shooting
								brake(delta)
						else:
							change_state(Enums.AIState.AIMING)
							
							brake(delta)
					else:
						if not is_state(Enums.AIState.DODGING):
							wait_to_shoot_timer.start()
							
							var radius: float = character.get_statistics().small_random_point_radius
							var random_location: Vector3 = get_random_location_from(target.global_transform.origin, radius)
							
							set_navigation_agent_target(random_location, false)
							
							change_state(Enums.AIState.DODGING)
						else:
							#Dodging
							move_agent(delta)
					
				else:
					if not is_state(Enums.AIState.APPROACHING):
						set_navigation_agent_target(last_seen_position)
						
						change_state(Enums.AIState.APPROACHING)
					elif is_target_far_from_final_location():
						set_navigation_agent_target(last_seen_position)
					else:
						move_agent(delta)
				
				aim(delta)
			else:
				if not is_state(Enums.AIState.SEARCHING):
					set_navigation_agent_target(last_seen_position)
					change_state(Enums.AIState.SEARCHING)
				else:
					move_agent(delta)
		else:
			var radius: float = character.get_statistics().idle_point_radius
			var random_location: Vector3 = get_random_location_from(spawn_position, radius)
			
			if not is_state(Enums.AIState.IDLE):
				set_navigation_agent_target(random_location)
				change_state(Enums.AIState.IDLE)
				
				idle_path_timer.start()
			else:
				move_agent(delta)


func move_agent(delta) -> void:
	if character.get_is_able_to_move():
		var navigation_agent: NavigationAgent = character.get_navigation_agent()
		var floor_raycast: RayCast = character.get_floor_raycast()
		
		var move_speed: float = character.get_statistics().move_speed
		
		if navigation_agent.is_target_reachable()\
		and not navigation_agent.is_target_reached():
			# Query the `NavigationAgent` to know the next free to reach location.
			var target_location = navigation_agent.get_next_location()
			var character_location = character.get_global_transform().origin
			
			# Floor normal.
			var floor_normal: Vector3 = floor_raycast.get_collision_normal()
			if floor_normal.length_squared() < 0.001:
				# Set normal to Y+ if on air.
				floor_normal = Vector3(0, 1, 0)
				
			# Calculate the velocity.
			var velocity: Vector3 = (target_location - character_location).slide(floor_normal).normalized() * move_speed
			
			look_at_path(delta)
			
			navigation_agent.set_velocity(velocity)
		else:
			brake(delta)


func look_at_path(delta) -> void:
	var navigation_agent: NavigationAgent = character.get_navigation_agent()
	var path = navigation_agent.get_nav_path()
	var index: int = navigation_agent.get_nav_path_index()
	
	if path.size() > 0:
		var look_at_point: Vector3 = path[index]
		look_at_point.y = character.global_transform.origin.y
		var turning_speed: float = character.get_statistics().turning_speed
				
		if not is_state(Enums.AIState.DODGING) \
		and not is_state(Enums.AIState.TARGET_AQUIRED):
			character.transform = character.smooth_look_at(character, look_at_point, turning_speed, delta)
				
			if is_state(Enums.AIState.SEARCHING)\
			or is_state(Enums.AIState.IDLE):
				var upper_part: Spatial = character.get_upper_part()
					
				upper_part.set_as_toplevel(true)
				upper_part.transform = character.smooth_look_at(upper_part, Vector3(look_at_point.x, upper_part.transform.origin.y, look_at_point.z), turning_speed, delta)
				upper_part.set_as_toplevel(false)


func set_navigation_agent_target(target_location: Vector3, override: bool = true, closest: bool = true) -> void:
	var navigation_agent: NavigationAgent = character.get_navigation_agent()
	
	if closest:
		var navigation: Navigation = navigation_agent.get_navigation()
		target_location = navigation.get_closest_point(target_location)
		
	
	if override\
	or navigation_agent.is_navigation_finished()\
	or navigation_agent.is_target_reached()\
	or not navigation_agent.is_target_reachable():
		navigation_agent.set_target_location(target_location)


func aim(delta) -> void:
	var turning_speed: float = character.get_statistics().turning_speed
	var upper_part: Spatial = character.get_upper_part()
	
	upper_part.set_as_toplevel(true)
	upper_part.transform = character.smooth_look_at(upper_part, offset + target.global_transform.origin, turning_speed, delta)
	upper_part.set_as_toplevel(false)


#func keep_distance(delta) -> void:
#	if close_character_list.size() > 0:
#		var direction: Vector3 = Vector3()
##		var velocity: Vector3 = character.velocity
#		var speed: float = self.character.get_statistics().move_speed
#		var accel: float = self.character.get_statistics().keep_distance_accel
#		var force_sum: Vector3 = Vector3()
#
#		for _character in close_character_list:
#			if is_instance_valid(character):
#				var force_component: Vector3 = (self.character.translation - _character.translation)
#				force_sum += force_component
#
#		direction = force_sum.normalized()
#		direction.y = 0
#
#		character.set_velocity(direction*speed, accel, delta)


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
	
	return not character.get_is_able_to_aim()


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


#func is_target_too_close() -> bool:
#	var target_position: Vector3 = target.translation
#	var distance: float = (target_position - self.character.translation).length()
#	var min_distance: float = self.character.get_statistics().min_distance
#
#	return distance < min_distance


func is_life_too_low() -> bool:
	var current_life: int = character.get_current_life()
	var max_life: int = character.get_life().max_life
	var relative_threshold: float = character.get_statistics().unable_to_fight_threshold
	var threshold: float = max_life * relative_threshold
	
	return current_life < threshold


func is_target_far_from_final_location() -> bool:
	var navigation_agent: NavigationAgent = character.get_navigation_agent()
	
	var target_location: Vector3 = target.global_transform.origin
	var final_agent_location: Vector3
	
	var distance: float = 0
	var max_distance_tollerance: float = character.get_statistics().max_distance_from_final_location
	
	final_agent_location = navigation_agent.get_target_location()
	
	distance = target_location.distance_to(final_agent_location)
	return distance > max_distance_tollerance


func update_last_seen_position():
	if target:
		last_seen_position = target.translation


func get_random_location_from(initial_location: Vector3, radius: float) -> Vector3:
	Util.rng.randomize()
	var random_location = initial_location + Vector3(Util.rng.randf_range(-radius, radius), character.global_transform.origin.y, Util.rng.randf_range(-radius, radius)) 
	
	return random_location


func change_state(new_state: int) -> void:
	var current_state: int = runtime_data.current_ai_state
	
	if current_state != new_state:
		runtime_data.current_ai_state = new_state
		GameEvents.emit_signal("state_changed", character, new_state)


func is_state(state: int) -> bool:
	var current_state: int = runtime_data.current_ai_state
	
	return current_state == state


func set_view_distance():
	var max_view_distance: int = character.get_statistics().max_view_distance
	var max_alert_distance: int = character.get_statistics().max_alert_distance

	character.get_view_area().get_child(0).shape.radius = max_alert_distance
	character.get_line_of_sight_raycast().cast_to = Vector3(0, 0, -max_view_distance)
	
	if character.get_view_area().connect("body_entered", self, "_on_view_area_body_entered") != OK:
		print("failure")


func set_min_distance():
	var min_distance: int = character.get_statistics().min_distance

	character.get_min_distance_area().get_child(0).shape.radius = min_distance

	if character.get_min_distance_area().connect("body_entered", self, "_on_min_distance_area_body_entered") != OK:
		print("failure")
	if character.get_min_distance_area().connect("body_exited", self, "_on_min_distance_area_body_exited") != OK:
		print("failure")
	pass


func setup_all_timers():
	var lost_target_time: float = character.get_statistics().lost_target_time
	var wait_to_shoot_time: float = character.get_statistics().wait_to_shoot_time
	var idle_path_time: float = character.get_statistics().wait_to_shoot_time
	
	lost_target_timer = Util.setup_timer(lost_target_timer, self, lost_target_time, false, true)
	wait_to_shoot_timer = Util.setup_timer(wait_to_shoot_timer, self, wait_to_shoot_time, false, true)
	idle_path_timer = Util.setup_timer(idle_path_timer, self, idle_path_time, false, true)


func get_current_ai_state() -> int:
	return runtime_data.current_ai_state


func _on_target_timer_timeout():
	runtime_data.current_ai_state = Enums.AIState.START
	GameEvents.emit_signal("target_changed", null, character)


func _on_wait_to_shoot_timer_timeout():
	can_shoot = !can_shoot


func _on_idle_path_timer_timeout():
	if is_state(Enums.AIState.IDLE):
		var radius: float = character.get_statistics().idle_point_radius
		var random_location: Vector3 = get_random_location_from(spawn_position, radius)
		
		set_navigation_agent_target(random_location, false)
		
		idle_path_timer.start()


func _on_character_shot(_character):
	if character.get_is_active():
		if _character.is_in_group("resistance"):
			if not target:
				var distance: float = (self.character.translation - _character.translation).length()
				var max_hear_distance: float = self.character.get_statistics().max_hear_distance
				
				if distance < max_hear_distance:
					GameEvents.emit_signal("target_changed", _character, self.character)
			else:
				update_last_seen_position()
				set_navigation_agent_target(last_seen_position, true)


func _on_target_changed(_target, _character):
	var new_target = null
		
	if _character == character:
		if _target:
			if _target.get_is_alive():
				new_target = _target
		
		target = new_target
		
		update_last_seen_position()
		set_navigation_agent_target(last_seen_position)


func _on_controller_changed(new_controller, old_controller) -> void:
	if old_controller == target:
		GameEvents.emit_signal("target_changed", new_controller, character)
		
	if new_controller.is_in_group("player"):
		offset = Vector3(0, player_offset, 0)
	elif new_controller.is_in_group("enemy"):
		offset = Vector3(0, enemy_offset, 0)


func _on_piece_ripped(_character, piece: DismountablePiece):
	if _character == character:
		var piece_tipology: int = piece.get_piece_tipology()
		match piece_tipology:
			Enums.PieceTipology.HEAD:
				character.set_is_able_to_aim(false)
			Enums.PieceTipology.WEAPON:
				character.set_is_able_to_shoot(false)
			Enums.PieceTipology.LEG:
				character.set_is_able_to_move(false)


func _on_died(_character):
	if _character == target:
		if target.is_in_group("player"):
			GameEvents.emit_signal("target_changed", null, self.character)


func _on_view_area_body_entered(body):
	if character.get_is_active():
		if not target:
			if body.is_in_group("resistance"):
				GameEvents.emit_signal("target_changed", body, character)


func _on_min_distance_area_body_entered(body):
	if body != self.character and not (body is StaticBody):
		close_character_list.append(body)


func _on_min_distance_area_body_exited(body):
	if body != self.character:
		var index: int = close_character_list.find(body)
		
		if index >= 0:
			close_character_list.remove(index)


func _on_NavigationAgent_velocity_computed(safe_velocity):
	character.set_instant_velocity(safe_velocity)
