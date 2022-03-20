extends RigidBody

class_name Bullet

export(NodePath) onready var mesh_instance = get_node(mesh_instance) as MeshInstance
export(NodePath) onready var despawn_timer = get_node(despawn_timer) as Timer
export(PackedScene) onready var explosion_reference

var _weapon
var _character

var target_point: Vector3

func initialize(start_position: Vector3, character):
	_weapon = character.get_current_weapon()
	_character = character
	
	mesh_instance.mesh = _weapon.get_ammo().get_mesh()
	self.transform.origin = start_position
	
	setup_despawn_timer()
	
	set_as_toplevel(true)


func _physics_process(delta):
	if _weapon:
		
		var direction: Vector3 = -transform.basis.z.normalized()
		linear_velocity = direction * _weapon.get_ammo().bullet_speed


func setup_despawn_timer() -> void:
	despawn_timer.wait_time = _weapon.get_ammo().bullet_life_time
	despawn_timer.autostart = false
	despawn_timer.one_shot = true
	
	despawn_timer.start()


func get_character() -> Character:
	return _character


func _on_DespawnTimer_timeout():
	queue_free()


func _on_CollisionArea_area_entered(area):
	if area is Shootable:
		GameEvents.emit_signal("hit", area, _weapon.damage)
	
	queue_free()


func spawn_explosion() -> void:
	var explosion = explosion_reference.instance()
	var particles: Particles = explosion.get_child(0)
	var audio_stream_player: AudioStreamPlayer3D = explosion.get_child(1)
	
	var sound_list: Dictionary = _weapon.get_sound_list()
	var sound_name: String = "explosion"
	
	Util.add_node_to_scene(explosion, self.translation)
	
	particles.emitting = true
	Util.play_random_sound_from_name(sound_name, sound_list, audio_stream_player, false, false)
	
	Util.set_node_despawnable(explosion, 8, true)


func _on_CollisionArea_body_entered(body):
	spawn_explosion()
	
	queue_free()
