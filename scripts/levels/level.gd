extends Spatial

class_name Level

export(Resource) var global_runtime_data = global_runtime_data as RuntimeData
export(NodePath) onready var player_spawn_position = get_node(player_spawn_position) as Position3D
export(NodePath) onready var player_parent = get_node(player_parent) as Node
export(PackedScene) onready var player_reference



func spawn_player() -> void:
	var player_instance: Player = player_reference.instance()
	var spawn_location: Vector3 = player_spawn_position.global_transform.origin
	
	Util.add_node_as_child(player_instance, player_parent, spawn_location)
	
	global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY
	
	GameEvents.emit_signal("change_controller", player_instance, null)


func win():
	print("win!")
	GameEvents.emit_signal("win")
