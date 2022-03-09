extends KinematicBody

class_name Character

export(Resource) var statistics = statistics as Statistics
export(Resource) var _runtime_data = _runtime_data as RuntimeData

export(NodePath) onready var audio_stream_player = get_node(audio_stream_player) as AudioStreamPlayer3D

export(NodePath) onready var life_manager = get_node(life_manager) as LifeManager

export(NodePath) onready var damage_area = get_node(damage_area) as Shootable


func _ready():
	_runtime_data.setup_local_to_scene()
	GameEvents.connect("died", self, "_on_died")


func _on_died(character) -> void:
	if character == self:
		print(name + " died")


func play_sound(audio_stream_player:AudioStreamPlayer3D, stream: AudioStream) -> void:
	if not audio_stream_player.is_playing():
		audio_stream_player.stream = stream
		audio_stream_player.playing = true


func set_life(_life: Life) -> void:
	statistics.life = _life


func get_life() -> Life:
	return statistics.life


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


func get_statistics() -> Statistics:
	return statistics
