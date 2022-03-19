extends PassiveCharacter

class_name Spawner

export(PackedScene) onready var enemy
export(float) onready var prevent_spawn_radius
export(bool) onready var active

var spawned_enemy: Enemy

export(NodePath) onready var prevent_spawn_area = get_node(prevent_spawn_area) as Area
export(NodePath) onready var spawn_parent = get_node(spawn_parent) as Node
export(NodePath) onready var busy_spawn_area_timer = get_node(busy_spawn_area_timer) as Timer
export(NodePath) onready var reset_timer = get_node(reset_timer) as Timer
export(NodePath) onready var spawn_position = get_node(spawn_position) as Position3D


func _ready():
	GameEvents.connect("spawn_enemy", self, "_on_spawn_enemy")

	set_prevent_spawn_area()
	
	SpawnManager.add_spawner(self)
	print(self.get_is_alive())


func set_prevent_spawn_area() -> void:
	var collision_shape: CollisionShape = prevent_spawn_area.get_child(0)
	var shape: Shape = collision_shape.shape
	
	shape.radius = prevent_spawn_radius


func _on_died(character) -> void:
	if character == self:
		self.set_is_alive(false)
		set_damage_area_off()
		active = false
		
		SpawnManager.remove_spawner(self)
		
		spawn_explosion()


func _on_spawn_enemy(spawner: Spawner) -> void:
	if self.get_is_alive():
		if spawner == self and active:
			if is_spawn_area_free():
				spawn_enemy()
			else:
				busy_spawn_area_timer.start()


func spawn_enemy() -> void:
	var enemy_instance = enemy.instance()
	
	spawn_parent.add_child(enemy_instance)
	
	enemy_instance.translation = spawn_position.get_global_transform().origin
	spawned_enemy = enemy_instance
	
	reset_timer.start()


func is_spawn_area_free() -> bool:
	var colliders = prevent_spawn_area.get_overlapping_bodies()
	
	for collider in colliders:
		if collider is ActiveCharacter:
			return false
	
	return true


func _on_BusySpawnAreaTimer_timeout():
	GameEvents.emit_signal("spawn_enemy", self)


func _on_PreventSpawnArea_body_exited(body):
	if self.get_is_alive():
		if body == spawned_enemy:
			SpawnManager.add_spawner(self)
			spawned_enemy = null


func _on_ResetTimer_timeout():
	if self.get_is_alive():
		if is_spawn_area_free():
			SpawnManager.add_spawner(self)
