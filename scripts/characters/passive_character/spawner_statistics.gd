extends PassiveCharacterStatistics

class_name SpawnerStatistics


export(PackedScene) var enemy_reference = load("res://nodes/enemy.tscn")
export(float, 1, 10) var prevent_spawn_radius
export(float) var spawn_time
