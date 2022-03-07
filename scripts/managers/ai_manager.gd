extends Manager

class_name AIManager

onready var runtime_data = character.get_runtime_data() as RuntimeData

var aim_target: Player
var shoot_target: Player
var aim_target_timer: Timer


func _ready():
	runtime_data.current_ai_state = Enums.AIState.IDLE
	
	set_aim_target_timer()
	aim_target_timer.connect("timeout", self, "_on_aim_target_timer_timeout")


func _physics_process(delta):
	check_target()
	
	
	if aim_target:
		runtime_data.current_ai_state = Enums.AIState.AIM
		character.look_at(aim_target.transform.origin, Vector3.UP)


func check_target() -> void:
	var raycasts: Array = character.get_ai_raycasts()
	
	for raycast in raycasts:
		var collider = raycast.get_collider()
	
		if collider is Player:
			if not aim_target:
				aim_target = collider
				aim_target_timer.start()



func _on_aim_target_timer_timeout():
	aim_target = null
	runtime_data.current_ai_state = Enums.AIState.IDLE


func set_aim_target_timer():
	aim_target_timer = Timer.new()
	add_child(aim_target_timer)
	
	aim_target_timer.wait_time = 5
	aim_target_timer.autostart = false
	aim_target_timer.one_shot = false
