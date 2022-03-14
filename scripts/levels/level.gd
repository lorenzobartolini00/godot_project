extends Spatial

class_name Level

export(Resource) var global_runtime_data = global_runtime_data as RuntimeData
export(NodePath) onready var player_spawn_position = get_node(player_spawn_position) as Position3D
export(PackedScene) onready var player_reference



func spawn_player() -> void:
	var player_instance: Player = player_reference.instance()
	add_child(player_instance)
	
	player_instance.translation = player_spawn_position.translation


func win():
	print("win!")
	GameEvents.emit_signal("win")
