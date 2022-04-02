extends Node

export(int) onready var total_enemies
export(int) onready var total_enemies_in_scene

var spawner_list: Array

var rng = RandomNumberGenerator.new()
var spawn_timer = Timer.new()


func _ready():
	get_tree().get_root().call_deferred("add_child", spawn_timer)
	spawn_timer.wait_time = 1
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout")


func _on_spawn_timer_timeout():
	update_total_enemies()
	spawn()


func add_spawner(spawner: Spawner) -> void:
	var index: int = spawner_list.find(spawner)
	
	if index < 0:
		spawner_list.append(spawner)


func remove_spawner(spawner: Spawner) -> void:
	var index: int = spawner_list.find(spawner)
	if index >= 0:
		spawner_list.remove(index)


func spawn():
	var spawner: Spawner
		
	if total_enemies_in_scene < total_enemies:
		if spawner_list.size() > 0:
			rng.randomize()
			var rnd_index: int = rng.randi() % spawner_list.size()
			spawner = spawner_list[rnd_index]
				
			GameEvents.emit_spawn_enemy(spawner)
					
			spawner_list.remove(rnd_index)
			
			update_total_enemies()
			

func update_total_enemies():
	total_enemies = 0
	var spawners = get_tree().get_nodes_in_group("Spawner")
	
	for spawner in spawners:
		if spawner.get_is_alive():
			total_enemies += 1
	
	total_enemies_in_scene = 0
	
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies:
		total_enemies_in_scene += 1
