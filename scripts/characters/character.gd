extends KinematicBody

class_name Character

export(Resource) var statistics = statistics as Statistics
export(Resource) var _runtime_data = _runtime_data as RuntimeData

export(NodePath) onready var audio_stream_player = get_node(audio_stream_player) as AudioStreamPlayer3D

export(NodePath) onready var life_manager = get_node(life_manager) as LifeManager

export(NodePath) onready var damage_area = get_node(damage_area) as Shootable

export(Resource) onready var current_life = current_life as Life

export(Array, Resource) onready var mesh_list


var rng = RandomNumberGenerator.new()
var despawn_timer = Timer.new()


func _ready():
	_runtime_data.setup_local_to_scene()
	GameEvents.connect("died", self, "_on_died")
	
	set_up_despawn_timer()


func _on_died(character) -> void:
	if character == self:
		print(name + " died")


func set_damage_area_off() -> void:
	var collision_shape: CollisionShape = damage_area.get_child(0)
	collision_shape.set_deferred("disabled", true)


func play_sound(audio_stream_player:AudioStreamPlayer3D, stream: AudioStream) -> void:
	if not audio_stream_player.is_playing():
		audio_stream_player.stream = stream
		audio_stream_player.playing = true
		
		if stream is AudioStreamMP3:
			stream.loop = false
		elif stream is AudioStreamSample:
			stream.loop_mode = AudioStreamSample.LOOP_DISABLED


func dismount() -> void:
	if mesh_list.size() > 0:
		for mesh in mesh_list:
			var new_rigid_body: RigidBody = RigidBody.new()
			var new_collision_shape: CollisionShape = CollisionShape.new()
			var new_mesh_instance: MeshInstance = MeshInstance.new()
			
			new_rigid_body.translation = self.translation
			new_rigid_body.rotation_degrees.y = self.rotation_degrees.y
			
			new_mesh_instance.mesh = mesh
			
			get_tree().get_root().add_child(new_rigid_body)
			new_rigid_body.add_child(new_mesh_instance)
			new_rigid_body.add_child(new_collision_shape)
			
			new_collision_shape.make_convex_from_brothers()
			
			var max_impulse_force: float = 10.0
			var max_impulse_position: float = 0.1
			rng.randomize()
			new_rigid_body.apply_impulse(Vector3(rng.randf_range(0, max_impulse_position), rng.randf_range(0, max_impulse_position), rng.randf_range(0, max_impulse_position)), Vector3(rng.randf_range(0, max_impulse_force), rng.randf_range(0, max_impulse_force), rng.randf_range(0, max_impulse_force)))
			



func set_up_despawn_timer():
	add_child(despawn_timer)
	
	despawn_timer.wait_time = 0.1
	despawn_timer.one_shot = true
	despawn_timer.autostart = false
	despawn_timer.connect("timeout", self, "_on_despawn_timer_timeout")


func _on_despawn_timer_timeout():
	dismount()
	
	queue_free()


func set_life(_life: Life) -> void:
	current_life = _life


func get_life() -> Life:
	return current_life


func set_current_life(_new_life: int) -> void:
	get_life().set_current_life(_new_life)


func get_current_life() -> int:
	return get_life().get_current_life()


func set_is_alive(_is_alive: bool) -> void:
	statistics.is_alive = _is_alive


func get_is_alive() -> bool:
	return statistics.is_alive


func get_audio_stream_player() -> AudioStreamPlayer:
	return audio_stream_player


func set_audio_stream_player(_audio_stream_player) -> void:
	audio_stream_player = _audio_stream_player


func get_runtime_data() -> RuntimeData:
	return _runtime_data

func set_statistics(_statistics: Statistics) -> void:
	statistics = _statistics


func get_statistics() -> Statistics:
	return statistics
