extends Manager

class_name AIManager

onready var runtime_data = character.get_runtime_data() as RuntimeData

var target
var last_seen_position: Vector3
var target_timer: Timer

var path: PoolVector3Array = []


func _ready():
	GameEvents.connect("target_changed", self, "_on_target_changed")
	runtime_data.current_ai_state = Enums.AIState.IDLE
	
	call_deferred("set_view_distance")
	
	set_aim_target_timer()
	target_timer.connect("timeout", self, "_on_target_timer_timeout")


func _physics_process(delta):
	if target:
		character.get_line_of_sight_raycast().set_as_toplevel(true)
		character.get_line_of_sight_raycast().look_at(target.translation, Vector3.UP)
		character.get_line_of_sight_raycast().set_as_toplevel(false)
		
		if is_target_in_direct_sight():
			target_timer.start()
			update_last_seen_position()
			
			if is_target_in_shoot_range():
				path = []

				if is_target_aquired():
					runtime_data.current_ai_state = Enums.AIState.TARGET_AQUIRED
				else:
					runtime_data.current_ai_state = Enums.AIState.AIMING
			else:
				if has_reach_last_seen_position():
					update_last_seen_position()

				runtime_data.current_ai_state = Enums.AIState.APPROACHING

				move(delta)
			
			aim(delta)
			
		else:
			if not has_reach_last_seen_position():
				runtime_data.current_ai_state = Enums.AIState.SEARCHING
				move(delta)


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


func has_reach_last_seen_position() -> bool:
	var distance: float = (last_seen_position - character.translation).length()
	var tollerance: float = character.get_statistics().max_distance_tollerance
	
	return distance < tollerance


func is_target_in_direct_sight() -> bool:
	var collider = character.get_line_of_sight_raycast().get_collider()
	
	if collider:
		if collider == target:
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


func update_last_seen_position():
	if target:
		last_seen_position = target.translation


func update_navigation_path(target: Vector3) ->void:
	if target:
		var navigation: Navigation = character.get_navigation()
		path = navigation.get_points(character, target)
	else:
		path = []


func set_view_distance():
	var max_view_distance: int = character.get_statistics().max_view_distance
	var max_alert_distance: int = character.get_statistics().max_alert_distance
	
	character.get_view_area().get_child(0).shape.radius = max_alert_distance
	character.get_line_of_sight_raycast().cast_to = Vector3(0, 0, -max_view_distance) 


func set_aim_target_timer():
	target_timer = Timer.new()
	add_child(target_timer)
	var lost_target_time: float = character.get_statistics().lost_target_time
	
	target_timer.wait_time = lost_target_time
	target_timer.autostart = false
	target_timer.one_shot = true


func _on_target_timer_timeout():
	runtime_data.current_ai_state = Enums.AIState.IDLE
	GameEvents.emit_signal("target_changed", null)


func _on_target_changed(_target):
	target = _target
	update_last_seen_position()


func _on_ViewArea_body_entered(body):
	if not target:
		if body.is_in_group("player"):
			GameEvents.emit_signal("target_changed", body)

