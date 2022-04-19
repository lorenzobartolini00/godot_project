extends Level

class_name Level0

#Obbiettivo del livello: trovare uscita
onready var spawner_count: int = get_tree().get_nodes_in_group("Spawner").size()
export(Resource) var description = description as Slide

func _ready():
	spawn_player()
	
	global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY
