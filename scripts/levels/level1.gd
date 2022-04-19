extends Level

class_name Level1

export(NodePath) onready var enter_door = get_node(enter_door) as Door
export(NodePath) onready var enter_door_2 = get_node(enter_door_2) as Door
export(NodePath) onready var console = get_node(console) as Console

export(Array, NodePath) onready var door_list
export(Array, Array, NodePath) onready var enemy_list

var enemy_count: int


func _ready():
	for list in enemy_list:
		get_node_from_path_list(list)
	
	get_node_from_path_list(door_list)
	
	update_enemy_count()
	
	if GameEvents.connect("open_door", self, "_on_door_opened") != OK:
		print("failure")
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")
	
	spawn_player()
	
	global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY


func _on_door_opened(door: Door, is_opened: bool):
	if door_list.size() > 0:
		if door == door_list[0]:
			if is_opened:
				if enemy_list.size() > 0:
					activate_enemies(enemy_list[0])
	
	if door == enter_door_2:
		if is_opened:
			console.set_is_active(false)


func _on_died(character: Character):
	var _enemy_list: Array
	var _door: Door
	
	if enemy_list.size() > 0:
		_enemy_list = enemy_list[0]
	
		if door_list.size() > 0:
			_door = door_list[0]
	
			check_enemy_count(character, _enemy_list, _door)


func is_stage_clear():
	return enemy_count == 0


func get_node_from_path_list(list: Array):
	var _list_path: Array = list
	
	list.clear()
	
	for node_path in list:
		var node = get_node(node_path) as Node
		list.append(node)


func activate_enemies(enemy_list):
	for enemy in enemy_list:
		enemy.set_is_active(true)


func check_enemy_count(died_character: Character, _enemy_list: Array, door_to_unlock: Door):
	for enemy in _enemy_list:
		if enemy == died_character:
			enemy_count -= 1
			
			if is_stage_clear():
				GameEvents.emit_signal("lock_door", door_to_unlock, false)
				
				enemy_list.pop_front()
				door_list.pop_front()


func update_enemy_count():
	if enemy_list[0].size() > 0:
		enemy_count = enemy_list[0].size()
