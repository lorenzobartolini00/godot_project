extends RigidBody

class_name Bullet

export(NodePath) onready var mesh_instance = get_node(mesh_instance) as MeshInstance
export(NodePath) onready var despawn_timer = get_node(despawn_timer) as Timer
export(NodePath) onready var explosion_area = get_node(explosion_area) as Area
export(NodePath) onready var trail_position = get_node(trail_position) as Position3D

var _weapon
var _character

onready var ready: bool = false

var target_point: Vector3

signal bullet_ready


func _ready():
	if self.connect("bullet_ready", self, "_on_bullet_ready") != OK:
		print("failure")


func initialize(start_position: Vector3, character):
	_weapon = character.get_current_weapon()
	_character = character
	
	mesh_instance.mesh = _weapon.get_ammo().get_bullet_mesh()
	self.transform.origin = start_position
	
	setup_explosion_area(_weapon.explosion_radius)
	
	setup_despawn_timer()
	
	set_as_toplevel(true)
	
	add_trail()
	
	
	emit_signal("bullet_ready", self)


func _physics_process(_delta):
	if _weapon and ready:
		var direction: Vector3 = -transform.basis.z.normalized()
		linear_velocity = direction * _weapon.get_ammo().bullet_speed


func setup_despawn_timer() -> void:
	despawn_timer.wait_time = _weapon.get_ammo().bullet_life_time
	despawn_timer.autostart = false
	despawn_timer.one_shot = true
	
	despawn_timer.start()


func setup_explosion_area(radius: float):
	var collision_shape: CollisionShape = explosion_area.get_child(0)
	var shape: SphereShape = collision_shape.shape
	
	shape.radius = radius


func _on_Bullet_body_entered(_body):
	explode()


func _on_DespawnTimer_timeout():
	queue_free()


func _on_bullet_ready(_bullet):
	if _bullet == self:
		ready = true


func explode():
	spawn_explosion()
	
	var colliders = explosion_area.get_overlapping_areas()
	
	for area in colliders:
		if area is Shootable:
			var damage: int = _weapon.damage
			
			var distance: float = self.global_transform.origin.distance_to(area.global_transform.origin)
			if distance > 0.01:
				damage = round(damage/ distance)
				
			var _damage: int = clamp(damage, 0 , _weapon.damage)
			
			GameEvents.emit_signal("hit", area, _damage)
	
	
	queue_free()


func add_trail():
	var trail_reference = _weapon.trail_reference
	var trail = trail_reference.instance()
	var trail_location: Vector3 = trail_position.translation
	
	Util.add_node_as_child(trail, trail_position, trail_location)


func spawn_explosion() -> void:
	var explosion = _weapon.explosion_reference.instance()
	var particles: Particles = explosion.get_child(0)
	var audio_stream_player: AudioStreamPlayer3D = explosion.get_child(1)
	
	var sound_list: Dictionary = _weapon.get_sound_list()
	var sound_name: String = "explosion"
	
	Util.add_node_to_scene(explosion, self.translation)
	
	particles.emitting = true
	Util.play_random_sound_from_name(sound_name, sound_list, audio_stream_player, false, false)
	
	Util.set_node_despawnable(explosion, 8, true)


func get_character() -> Character:
	return _character


func get_weapon() -> Weapon:
	return _weapon
