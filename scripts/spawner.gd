extends PassiveCharacter

class_name Spawner


export(bool) var is_active:= true
export(bool) var is_timer_active:= true

export(NodePath) onready var prevent_spawn_area = get_node(prevent_spawn_area) as Area
export(NodePath) onready var spawn_parent = get_node(spawn_parent) as Node
export(NodePath) onready var spawn_timer = get_node(spawn_timer) as Timer
export(NodePath) onready var spawn_position = get_node(spawn_position) as Position3D
export(NodePath) onready var spawner_animation_player = get_node(spawner_animation_player) as AnimationPlayer

export(Dictionary) var enemy_properties = {
	"is_alive" : true,
	"is_invulnerable" : false,
	"is_active" : false,
	"is_able_to_move" : true,
	"is_able_to_aim" : true,
	"is_able_to_shoot" : true,
	"idle_points" : [Vector3(0,0,0), Vector3(0,0,0), Vector3(0,0,0)]
	}


var spawned_enemy: Enemy


func _ready():
	if spawn_timer.connect("timeout", self, "_on_spawn_timer_timeout") != OK:
		print("failure")
	
	spawn_timer.wait_time = self.get_statistics().spawn_time
	
	if is_timer_active:
		spawn_timer.start()
	
	set_prevent_spawn_area()


func spawn() -> Enemy:
	if get_is_active():
		if is_spawn_area_free() and not spawned_enemy:
			var enemy_reference: PackedScene = self.get_statistics().enemy_reference
			var enemy_instance = enemy_reference.instance()
			var spawn_location: Vector3 = spawn_position.global_transform.origin
			
			Util.add_node_as_child(enemy_instance, spawn_parent, spawn_location)
			
			spawned_enemy = enemy_instance
			
			set_properties()
		
			spawn_timer.stop()
			
			spawner_animation_player.play("spawn")
		else:
			if is_timer_active:
				spawn_timer.start()
	
	return spawned_enemy


func set_prevent_spawn_area() -> void:
	var collision_shape: CollisionShape = prevent_spawn_area.get_child(0)
	var shape: Shape = collision_shape.shape
	
	shape.radius = self.get_statistics().prevent_spawn_radius


func _on_died(character) -> void:
	._on_died(character)
	
	if character == self:
		self.set_is_active(false)
		
		spawn_explosion()
	elif character == spawned_enemy:
		spawned_enemy = null
		
		if is_timer_active:
			spawn_timer.start()


func is_spawn_area_free() -> bool:
	var colliders = prevent_spawn_area.get_overlapping_bodies()
	
	for collider in colliders:
		if collider is ActiveCharacter:
			return false
	
	return true


func set_properties() -> void:
	var property_list: Array = enemy_properties.keys()
	
	for prop in property_list:
		var value = enemy_properties.get(prop)
		
		spawned_enemy.set(prop, value)


func _on_spawn_timer_timeout():
	spawn()


func get_is_active() -> bool:
	return is_active


func set_is_active(_is_active: bool) -> void:
	is_active =  _is_active
