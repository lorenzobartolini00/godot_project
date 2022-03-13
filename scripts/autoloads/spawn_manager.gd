extends Node

export(int) onready var total_enemies
export(int) onready var total_enemies_in_scene

var spawner_list: Array

var rng = RandomNumberGenerator.new()
var spawn_timer = Timer.new()


func _ready():
	get_tree().get_root().call_deferred("add_child", spawn_timer)
	spawn_timer.wait_time = 5
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")
	
	GameEvents.connect("play", self, "_on_play")


func _on_play(index: int):
	total_enemies_in_scene = 0
#	update_enemy_count()


#func _on_died(character):
#	if character is Enemy:
#		update_enemy_count()


func _on_spawn_timer_timeout():
	update_enemy_count()


func add_spawner(spawner: Spawner) -> void:
	var index: int = spawner_list.find(spawner)
	
	if index < 0:
		spawner_list.append(spawner)


func remove_spawner(spawner: Spawner) -> void:
	var index: int = spawner_list.find(spawner)
	if index >= 0:
		spawner_list.remove(index)


func update_enemy_count():
	total_enemies = get_tree().get_nodes_in_group("Spawner").size()
	
	var spawner: Spawner
	var try: int = 0
			
	if total_enemies_in_scene < total_enemies:
		if spawner_list.size() > 0:
			rng.randomize()
			var rnd_index: int = rng.randi() % spawner_list.size()
			spawner = spawner_list[rnd_index]
				
			GameEvents.emit_spawn_enemy(spawner)
					
			spawner_list.remove(rnd_index)
