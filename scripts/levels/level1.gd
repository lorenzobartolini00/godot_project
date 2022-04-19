extends Level

class_name Level1

export(NodePath) onready var enter_door = get_node(enter_door) as Door
export(NodePath) onready var locked_door = get_node(locked_door) as Door
export(Array, NodePath) onready var enemy_list_path

var enemy_list: Array
var enemy_count: int


func _ready():
	for enemy_path in enemy_list_path:
		var enemy = get_node(enemy_path) as Enemy
		enemy_list.append(enemy)
	
	enemy_count = enemy_list.size()
	
	if GameEvents.connect("open_door", self, "_on_door_opened") != OK:
		print("failure")
	if GameEvents.connect("died", self, "_on_died") != OK:
		print("failure")
	
	spawn_player()
	
	global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY


func _on_door_opened(door: Door, is_opened: bool):
	if door == enter_door:
		for enemy in enemy_list:
			enemy.set_is_active(true)


func _on_died(character: Character):
	for enemy in enemy_list:
		if enemy == character:
			enemy_count -= 1
			
			check_stage_clear()


func check_stage_clear():
	if enemy_count == 0:
		GameEvents.emit_signal("unlock_door", locked_door)
