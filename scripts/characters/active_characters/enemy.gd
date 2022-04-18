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

export(NodePath) onready var aim_remote_transform_player = get_node(aim_remote_transform_player) as RemoteTransform
export(NodePath) onready var aim_remote_transform_bot = get_node(aim_remote_transform_bot) as RemoteTransform

export(Array, Vector3) onready var idle_points

export(NodePath) onready var particle_trace = get_node(particle_trace) as Particles

export(Resource) onready var life_slot = life_slot as LifeSlot

export(bool) onready var is_able_to_shoot
export(bool) onready var is_able_to_aim
export(bool) onready var is_able_to_move

onready var navigation = get_parent() as Navigation

var player_controller


func choose_random_weapon():
	var weapon_list = Util.load_folder("res://my_resources/weapon_statistics/", true)
	
	rng.randomize()
	var rnd_index: int = rng.randi() % weapon_list.size()
	
	var weapon: Weapon = weapon_list[rnd_index]
	GameEvents.emit_signal("change_current_weapon", weapon, self)


#Override
func bot_behaviour(delta):
	.bot_behaviour(delta)
	
	if get_is_active():
		ai_manager.ai_movement(delta)
		
		if _runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED:
			shoot_manager.shoot(delta)
				
		if reload_manager.need_reload() and reload_manager.can_reload():
			reload_manager.reload()
		
		if get_is_able_to_aim():
			rotate_weapon(delta)
		
		sonar_effect()


#Override
func player_behaviour(delta):
	.player_behaviour(delta)
	
	if Input.is_action_just_pressed("interact"):
		GameEvents.emit_signal("change_controller", player_controller, self)
		player_controller = null
	
	if get_is_able_to_aim():
			rotate_weapon(delta)


#Override
func _on_died(character) -> void:
	._on_died(character)
	
	if character == self:
		character.set_is_alive(false)
		
		dismount()
		spawn_explosion()
		
		if is_current_controller:
			GameEvents.emit_change_controller(get_player_controller(), self)
		
		queue_free()


func _on_controller_changed(new_controller, _old_controller) -> void:
	._on_controller_changed(new_controller, _old_controller)
	
	var aim_raycast_path: String = aim_raycast.get_path()
	var null_path: String = ""
	
	if new_controller == self:
		aim_remote_transform_player.remote_path = aim_raycast_path
		aim_remote_transform_bot.remote_path = null_path
	elif _old_controller == self:
		aim_remote_transform_player.remote_path = null_path
		aim_remote_transform_bot.remote_path = aim_raycast_path


func sonar_effect():
	if self.velocity.length() > 1:
		if not particle_trace.emitting:
				
			particle_trace.emitting = true
		else:
			self.sound_manager.play_on_character_stream_player("sonar")
	else:
		particle_trace.emitting = false


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


func get_player_controller() -> Node:
	return player_controller


func set_player_controller(controller: Node) -> void:
	player_controller = controller


func get_idle_points() -> Array:
	return idle_points


func set_idle_points(_idle_points: Array) -> void:
	idle_points = _idle_points


func get_life_slot() -> LifeSlot:
	return life_slot


#Properties
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


