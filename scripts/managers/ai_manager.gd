extends Manager

class_name AIManager

onready var runtime_data = character.get_runtime_data() as RuntimeData

var aim_target
var shoot_target
var target_timer: Timer

var path: PoolVector3Array = []


func _ready():
	runtime_data.current_ai_state = Enums.AIState.IDLE
	
	set_aim_target_timer()
	target_timer.connect("timeout", self, "_on_aim_target_timer_timeout")


func _physics_process(delta):
	check_aim_target()
	check_shoot_target()
	
	
	if aim_target:
		runtime_data.current_ai_state = Enums.AIState.AIM
		
		if shoot_target:
			runtime_data.current_ai_state = Enums.AIState.TARGET_AQUIRED
		else:
			var navigation: Navigation = character.get_navigation() 
			path = navigation.navigate(character, path, delta)
		
		var turning_speed: float = character.get_statistics().turning_speed
		
		if runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED:
			character.transform = character.smooth_look_at(character.transform, aim_target.transform.origin, turning_speed, delta)


func check_aim_target() -> void:
	var raycasts: Array = character.get_ai_raycasts()
	
	for raycast in raycasts:
		if aim_target:
			raycast.cast_to.z = -character.get_statistics().max_view_distance
		else:
			raycast.cast_to.z = -character.get_statistics().min_view_distance
		
		var collider = raycast.get_collider()
	
		if collider:
			if collider.is_in_group("player"):
				if not aim_target:
					aim_target = collider
					update_navigation_path(aim_target.translation)
					
					target_timer.start()
				


func check_shoot_target() -> void:
	if aim_target:
		var raycast: RayCast = character.get_shooting_raycast()
		var collider = raycast.get_collider()
		
		if collider is Shootable:
			shoot_target = aim_target
			target_timer.start()
		else:
			shoot_target = null


func update_navigation_path(target: Vector3) ->void:
	if target:
		var navigation: Navigation = character.get_navigation()
		path = navigation.get_points(character, target)
	else:
		path = []



func _on_aim_target_timer_timeout():
	aim_target = null
	shoot_target = null
	path = []
	
	runtime_data.current_ai_state = Enums.AIState.IDLE


func set_aim_target_timer():
	target_timer = Timer.new()
	add_child(target_timer)
	
	target_timer.wait_time = 1
	target_timer.autostart = false
	target_timer.one_shot = true
