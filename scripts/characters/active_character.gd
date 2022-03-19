extends Character

class_name ActiveCharacter

export var _gravity: float = -2.5
export var _acceleration: float = 10.0
export var _air_acceleration: float = 2.0
export var _vertical_acceleration: float = 5

const MAX_TERMINAL_VELOCITY: float = 50.0

var velocity: Vector3

export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(Resource) onready var current_weapon = current_weapon as Weapon
export(NodePath) onready var current_weapon_mesh = get_node(current_weapon_mesh) as MeshInstance
export(NodePath) onready var weapon_position = get_node(weapon_position) as Spatial

export(NodePath) onready var weapon_manager = get_node(weapon_manager) as WeaponManager
export(NodePath) onready var ammo_manager = get_node(ammo_manager) as AmmoManager
export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager

export(NodePath) onready var weapon_audio_stream_player = get_node(weapon_audio_stream_player) as AudioStreamPlayer3D



func smooth_look_at(object: Spatial, target_position: Vector3, speed: float, delta: float) -> Transform:
	var transform: Transform = object.transform 
	var new_transform: Transform = transform.looking_at(target_position, Vector3.UP)
	var next_transform: Transform = transform.interpolate_with(new_transform, speed * delta)
	
	return next_transform


func check_target():
	var collider = shooting_raycast.get_collider()
	
	if collider:
		if collider is Shootable:
			GameEvents.emit_signal("target_acquired", self, Enums.TargetTipology.SHOOTABLE)
		else:
			GameEvents.emit_signal("target_acquired", self, Enums.TargetTipology.NO_TARGET)
	else:
		GameEvents.emit_signal("target_acquired", self, Enums.TargetTipology.NO_TARGET)


func set_current_weapon(_current_weapon: Weapon) -> void:
	current_weapon = _current_weapon


func get_current_weapon() -> Weapon:
	return current_weapon
	

func set_current_weapon_mesh(_mesh: Mesh) -> void:
	current_weapon_mesh.mesh = _mesh


func get_current_weapon_mesh() -> Mesh:
	return current_weapon_mesh


func set_shooting_raycast(raycast: RayCast) -> void:
	shooting_raycast = raycast


func get_shooting_raycast() -> RayCast:
	return shooting_raycast


func set_weapon_position(spatial: Spatial) -> void:
	weapon_position = spatial


func get_weapon_position() -> Spatial:
	return weapon_position


func get_weapon_audio_stream_player() -> AudioStreamPlayer:
	return weapon_audio_stream_player
