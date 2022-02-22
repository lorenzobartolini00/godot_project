extends KinematicBody

class_name Character

export(Resource) var statistics = statistics as Statistics
export(Resource) var _runtime_data = _runtime_data as RuntimeData
export(NodePath) onready var _current_weapon_mesh = get_node(_current_weapon_mesh) as MeshInstance

export(NodePath) onready var weapon_manager = get_node(weapon_manager) as WeaponManager
export(NodePath) onready var life_manager = get_node(life_manager) as LifeManager

func _ready():
	_runtime_data.setup_local_to_scene()
	GameEvents.connect("died", self, "_on_died")
	GameEvents.connect("collected", self, "_on_collected")
	
#	GameEvents.emit_signal("collected", self.get_current_weapon(), 1, self)


func _on_collected(_item: Item, _quantity: int, character):
	if character == self:
		weapon_manager.change_current_weapon(_item)


func _on_died(character) -> void:
	if character == self:
		print(name + " died")


func set_current_weapon(_current_weapon: Weapon) -> void:
	statistics.current_weapon = _current_weapon


func get_current_weapon() -> Weapon:
	return statistics.current_weapon
	

func set_current_weapon_mesh(_mesh: Mesh) -> void:
	_current_weapon_mesh.mesh = _mesh


func get_current_weapon_mesh() -> Mesh:
	return _current_weapon_mesh


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


func get_runtime_data() -> RuntimeData:
	return _runtime_data
