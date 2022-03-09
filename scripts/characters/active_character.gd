extends Character

class_name ActiveCharacter

export(NodePath) onready var shooting_raycast = get_node(shooting_raycast) as RayCast

export(NodePath) onready var current_weapon_mesh = get_node(current_weapon_mesh) as MeshInstance
export(NodePath) onready var weapon_position = get_node(weapon_position) as Spatial

export(NodePath) onready var weapon_manager = get_node(weapon_manager) as WeaponManager
export(NodePath) onready var ammo_manager = get_node(ammo_manager) as AmmoManager
export(NodePath) onready var shoot_manager = get_node(shoot_manager) as ShootManager
export(NodePath) onready var reload_manager = get_node(reload_manager) as ReloadManager



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


func set_current_weapon(_current_weapon: Weapon) -> void:
	get_statistics().current_weapon = _current_weapon


func get_current_weapon() -> Weapon:
	return get_statistics().current_weapon
	

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
