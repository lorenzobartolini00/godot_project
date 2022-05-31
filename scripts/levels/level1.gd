extends Level

class_name Level1

export(NodePath) onready var turn_off_console_door = get_node(turn_off_console_door) as Door
export(NodePath) onready var final_area_door = get_node(final_area_door) as Door
export(Array, NodePath) onready var enter_door_list
export(Array, NodePath) var exit_door_list
export(NodePath) onready var console = get_node(console) as Console
export(NodePath) onready var switch = get_node(switch) as Switch
export(NodePath) onready var win_timer = get_node(win_timer) as Timer

export(Array, Array, NodePath) var enemy_list

var enemy_count: int
var stage_index: int = 0


func _ready():
	for list in enemy_list:
		var index: int = enemy_list.find(list)
		
		enemy_list[index] = get_node_from_path_list(list)
	
	enter_door_list = get_node_from_path_list(enter_door_list)
	exit_door_list = get_node_from_path_list(exit_door_list)
	
	update_enemy_count()
	
	if GameEvents.connect("open_door", self, "_on_door_opened") != OK:
		print("failure")
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")
	if switch.connect("switch_pressed", self, "_on_switch_pressed") != OK:
		print("failure")
	
	spawn_player()
	
	change_music("relax")
	
	global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY


func _on_door_opened(_door: Door, _is_opened: bool):
	if _door == exit_door_list[1]:
		GameEvents.emit_signal("lock_door", final_area_door, false)
	
	if _door == exit_door_list[2] and _is_opened:
		stop_music()
	
	if _door == turn_off_console_door:
		if _is_opened:
			console.set_is_active(false)
	
	var current_enter_door = get_current_enter_door()
	
	if current_enter_door:
		if current_enter_door == _door and _is_opened:
			var current_enemy_list = get_current_enemy_list()
			
			#Controllo che la dimensione della lista sia maggiore di 0 perchè nel caso in cui
			#lo stage_index sia arrivato al valore massimo, il metodo get_current_enemy_list() restituisce un array vuoto
			if current_enemy_list.size() > 0:
				activate_enemies(current_enemy_list)


func _on_died(character: Character):
	var current_enemy_list: Array = get_current_enemy_list()
	
	#Controllo che la dimensione della lista sia maggiore di 0 perchè nel caso in cui
	#lo stage_index sia arrivato al valore massimo, il metodo get_current_enemy_list() restituisce un array vuoto
	if current_enemy_list.size() > 0:
		if current_enemy_list.has(character):
			enemy_count -= 1
		
		if is_stage_clear():
			next_stage()


func next_stage():
	var door_to_unlock: Door = get_current_exit_door()
	
	if door_to_unlock:
		GameEvents.emit_signal("lock_door", door_to_unlock, false)
		
		change_music("relax")
		
	stage_index += 1
		
	update_enemy_count()


func is_stage_clear():
	return enemy_count == 0


func get_node_from_path_list(list: Array) -> Array:
	var _list_path: Array = []
	
	for node_path in list:
		var node = get_node(node_path) as Node
		_list_path.append(node)
	
	return _list_path


func activate_enemies(_enemy_list: Array):
	change_music("fight")
	
	for enemy in _enemy_list:
		enemy.set_is_active(true)


func get_current_enter_door() -> Door:
	if stage_index < enter_door_list.size():
		return enter_door_list[stage_index]
	else:
		return null

func get_current_exit_door() -> Door:
	if stage_index < exit_door_list.size():
		return exit_door_list[stage_index]
	else:
		return null


func get_current_enemy_list() -> Array:
	if stage_index < enemy_list.size():
		return enemy_list[stage_index]
	else:
		return []


func update_enemy_count():
	var current_enemy_list: Array = get_current_enemy_list()
	
	if current_enemy_list.size() > 0:
		enemy_count = current_enemy_list.size()
	else:
		enemy_count = 0


func _on_switch_pressed(_switch: Switch):
	if _switch == switch:
		win_timer.start()




func _on_WinTimer_timeout():
	win()
