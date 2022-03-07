extends Manager

class_name AIManager

onready var runtime_data = character.get_runtime_data() as RuntimeData

var aim_target: Player
var shoot_target: Player
var target_timer: Timer


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
		
		
		character.look_at(aim_target.transform.origin, Vector3.UP)


func check_aim_target() -> void:
	var raycasts: Array = character.get_ai_raycasts()
	
	for raycast in raycasts:
		var collider = raycast.get_collider()
	
		if collider is Player:
			if not aim_target:
				aim_target = collider
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


func _on_aim_target_timer_timeout():
	aim_target = null
	shoot_target = null
	runtime_data.current_ai_state = Enums.AIState.IDLE


func set_aim_target_timer():
	target_timer = Timer.new()
	add_child(target_timer)
	
	target_timer.wait_time = 20
	target_timer.autostart = false
	target_timer.one_shot = true
