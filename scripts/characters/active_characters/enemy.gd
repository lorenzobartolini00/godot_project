extends ActiveCharacter

class_name Enemy

export(NodePath) onready var line_of_sight_raycast = get_node(line_of_sight_raycast) as RayCast
export(NodePath) onready var weapon_line_of_sight_raycast = get_node(weapon_line_of_sight_raycast) as RayCast
export(NodePath) onready var view_area = get_node(view_area) as Area
export(NodePath) onready var min_distance_area = get_node(min_distance_area) as Area
export(NodePath) onready var upper_part = get_node(upper_part) as Spatial

export(NodePath) onready var ai_manager = get_node(ai_manager) as AIManager

onready var navigation = get_parent() as Navigation

var direction_1: Vector3
var direction_2: Vector3

func _ready():
	choose_random_weapon()
	SpawnManager.total_enemies_in_scene += 1


func choose_random_weapon():
	var weapon_list: Array = Util.load_folder("res://my_resources/weapon_statistics/")
	
	rng.randomize()
	var rnd_index: int = rng.randi() % weapon_list.size()
	
	var weapon: Weapon = weapon_list[rnd_index]
	GameEvents.emit_signal("change_current_weapon", weapon, self)


func _physics_process(delta):
	if get_is_alive():
		if _runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED:
			shoot_manager.shoot(delta)
		
		if reload_manager.need_reload():
			reload_manager.reload()
	
	var y_movement = velocity.y
	
	if not is_on_floor():
		y_movement = lerp(y_movement, y_movement + _gravity, delta * _vertical_acceleration)
		y_movement = clamp(y_movement, -MAX_TERMINAL_VELOCITY, MAX_TERMINAL_VELOCITY)
	else:
		y_movement = -0.1
	
	velocity.y = y_movement
	move_and_slide(velocity, Vector3.UP)


#Override
func _on_died(character) -> void:
	if character == self:
		character.set_is_alive(false)
		print(name + " died")
		set_damage_area_off()
		SpawnManager.total_enemies_in_scene -= 1
		
		self.despawn_timer.start()


func get_navigation() -> Navigation:
	return navigation


func get_line_of_sight_raycast() -> RayCast:
	return line_of_sight_raycast


func get_weapon_line_of_sight_raycast() -> RayCast:
	return weapon_line_of_sight_raycast


func get_view_area() -> Area:
	return view_area


func get_min_distance_area() -> Area:
	return min_distance_area


func get_upper_part() -> Spatial:
	return upper_part

