extends Spatial

class_name Level

export(Resource) var global_runtime_data = global_runtime_data as RuntimeData
export(NodePath) onready var player_spawn_position = get_node(player_spawn_position) as Position3D
export(NodePath) onready var player_parent = get_node(player_parent) as Node
export(NodePath) onready var soundtrack_audio_stream_player = get_node(soundtrack_audio_stream_player) as AudioStreamPlayer
export(NodePath) onready var soundtrack_animation_player = get_node(soundtrack_animation_player) as AnimationPlayer
export(Dictionary) var sound_track = {
	"fight" : preload("res://assets/my_assets/sounds/soundtrack/robo-cop-synthwave-100bpm-117s-12714.mp3"),
	"relax" : preload("res://assets/my_assets/sounds/soundtrack/just-a-click-away-sci-fi-background-music-109864.mp3")
}
export(PackedScene) onready var player_reference

var current_soundtrack: AudioStream


func _ready():
	if soundtrack_animation_player.connect("animation_finished", self, "_on_animation_finished") != OK :
		print("failure")


func spawn_player() -> void:
	var player_instance: Player = player_reference.instance()
	var spawn_location: Vector3 = player_spawn_position.global_transform.origin
	
	Util.add_node_as_child(player_instance, player_parent, spawn_location)
	
	player_instance.rotation = player_spawn_position.rotation
	
	global_runtime_data.current_gameplay_state = Enums.GamePlayState.PLAY
	
	GameEvents.emit_change_controller(player_instance, null)


func play_music():
	soundtrack_audio_stream_player.stream = current_soundtrack
	
	soundtrack_animation_player.play("fade_in")


func change_music(name: String, on_loop: bool = true):
	current_soundtrack = sound_track.get(name)
	current_soundtrack.loop = on_loop
	
	if(soundtrack_audio_stream_player.stream):
		soundtrack_audio_stream_player.stream.loop = false
	
	soundtrack_animation_player.play("fade_out")


func stop_music():
	soundtrack_animation_player.play("stop")


func win():
	print("win!")
	GameEvents.emit_signal("win")


func _on_animation_finished(anim_name: String):
	if anim_name == "fade_out":
		play_music()
