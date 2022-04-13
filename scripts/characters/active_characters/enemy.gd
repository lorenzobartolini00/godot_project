extends BasicFirstPersonController

class_name Enemy

export(NodePath) onready var line_of_sight_raycast = get_node(line_of_sight_raycast) as RayCast
export(NodePath) onready var weapon_line_of_sight_raycast = get_node(weapon_line_of_sight_raycast) as RayCast
export(NodePath) onready var view_area = get_node(view_area) as Area
export(NodePath) onready var min_distance_area = get_node(min_distance_area) as Area
export(NodePath) onready var upper_part = get_node(upper_part) as Spatial
export(NodePath) onready var navigation_agent = get_node(navigation_agent) as NavigationAgent

export(NodePath) onready var ai_manager = get_node(ai_manager) as AIManager

export(NodePath) onready var ai_audio_stream_player = get_node(ai_audio_stream_player) as AudioStreamPlayer3D
export(NodePath) onready var enemy_model = get_node(enemy_model) as Spatial

onready var navigation = get_parent() as Navigation

var player_controller

export(bool) onready var asleep
export(bool) onready var is_able_to_shoot
export(bool) onready var is_able_to_aim
export(bool) onready var is_able_to_move


func _ready():
	choose_random_weapon()
	SpawnManager.total_enemies_in_scene += 1


func choose_random_weapon():
	var weapon_list = Util.load_folder("res://my_resources/weapon_statistics/", true)
	
	rng.randomize()
	var rnd_index: int = rng.randi() % weapon_list.size()
	
	var weapon: Weapon = weapon_list[rnd_index]
	GameEvents.emit_signal("change_current_weapon", weapon, self)


#Override
func bot_behaviour(delta):
	.bot_behaviour(delta)
	
	if not asleep:
		ai_manager.ai_movement(delta)
		
		if _runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED:
			shoot_manager.shoot(delta)
				
		if reload_manager.need_reload() and reload_manager.can_reload():
			reload_manager.reload()


#Override
func player_behaviour(delta):
	.player_behaviour(delta)
	
	if Input.is_action_just_pressed("interact"):
		GameEvents.emit_signal("change_controller", player_controller)
		player_controller = null


#Override
func _on_died(character) -> void:
	if character == self:
		character.set_is_alive(false)
		
		SpawnManager.total_enemies_in_scene -= 1
		
		set_damage_area_off()
		dismount()
		spawn_explosion()
		
		queue_free()


func get_navigation() -> Navigation:
	return navigation


func get_line_of_sight_raycast() -> RayCast:
	return line_of_sight_raycast


func get_weapon_line_of_sight_raycast() -> RayCast:
	return weapon_line_of_sight_raycast


func get_navigation_agent() -> NavigationAgent:
	return navigation_agent


func get_view_area() -> Area:
	return view_area


func get_min_distance_area() -> Area:
	return min_distance_area


func get_upper_part() -> Spatial:
	return upper_part

func get_ai_audio_stream_player() -> AudioStreamPlayer3D:
	return ai_audio_stream_player


func get_is_able_to_shoot() -> bool:
	return is_able_to_shoot


func set_is_able_to_shoot(_is_able_to_shoot: bool):
	is_able_to_shoot = _is_able_to_shoot


func get_is_able_to_aim() -> bool:
	return is_able_to_aim


func set_is_able_to_aim(_is_able_to_aim: bool):
	is_able_to_aim = _is_able_to_aim


func get_is_able_to_move() -> bool:
	return is_able_to_move


func set_is_able_to_move(_is_able_to_move: bool):
	is_able_to_move = _is_able_to_move


func get_player_controller() -> Node:
	return player_controller


func set_player_controller(controller: Node) -> void:
	player_controller = controller


