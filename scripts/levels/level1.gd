extends Level

class_name Level1

export(NodePath) onready var turn_off_console_door = get_node(turn_off_console_door) as Door
export(NodePath) onready var final_area_door = get_node(final_area_door) as Door
export(Array, NodePath) onready var enter_door_list
export(Array, NodePath) var exit_door_list
export(NodePath) onready var console = get_node(console) as Console

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
	
	spawn_player()
	
	global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY


func _on_door_opened(_door: Door, _is_opened: bool):
	activate_enemies_on_door_unlocked(enemy_list[stage_index], enter_door_list[stage_index], _door, _is_opened)
	
	if _door == exit_door_list[2]:
		GameEvents.emit_signal("lock_door", final_area_door, false)
	
	if _door == turn_off_console_door:
		if _is_opened:
			console.set_is_active(false)


func activate_enemies_on_door_unlocked(_enemy_list: Array, door: Door, opened_door: Door, _is_opened: bool) -> void:
	if door == opened_door:
		if _is_opened:
			activate_enemies(_enemy_list)


func _on_died(character: Character):
	var _enemy_list: Array
	var _door: Door
	
	if enemy_list.size() > 0:
		_enemy_list = enemy_list[stage_index]
	
		check_enemy_count(character, _enemy_list)
		
		if is_stage_clear():
			var door_to_unlock: Door = exit_door_list[stage_index]
			GameEvents.emit_signal("lock_door", door_to_unlock, false)
			
			
			if stage_index < enemy_list.size():
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
	for enemy in _enemy_list:
		enemy.set_is_active(true)


func check_enemy_count(died_character: Character, _enemy_list: Array):
	for enemy in _enemy_list:
		if enemy == died_character:
			enemy_count -= 1


func update_enemy_count():
	if stage_index < enemy_list.size():
		enemy_count = enemy_list[stage_index].size()
	else:
		enemy_count = 0


func _on_WinArea_body_entered(body):
	if body.is_in_group("resistance"):
		win()
