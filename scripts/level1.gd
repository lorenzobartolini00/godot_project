extends Level

#Obbiettivo del livello: distruggere tutti gli spawner
onready var spawner_count: int = get_tree().get_nodes_in_group("Spawner").size()
export(Resource) var description = description as Slide


func _ready():
	GameEvents.connect("died", self, "_on_died")
	
	GameEvents.emit_signal("new_mission", self)


func _on_died(character: Character):
	if character is Spawner:
		spawner_count -= 1
	
	call_deferred("check_victory")


func check_victory():
	if spawner_count == 0 and SpawnManager.total_enemies_in_scene == 0:
		win()
