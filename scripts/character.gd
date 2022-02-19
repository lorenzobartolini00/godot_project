extends KinematicBody

class_name Character

export(Resource) var statistics = statistics as Statistics
export(Resource) var _runtime_data = _runtime_data as RuntimeData


func _ready():
	_runtime_data.setup_local_to_scene()
	GameEvents.connect("died", self, "_on_died")


func _on_died(character) -> void:
	if character == self:
		print(name + " died")


func set_current_weapon(_current_weapon: Weapon) -> void:
	statistics.current_weapon = _current_weapon


func get_current_weapon() -> Weapon:
	return statistics.current_weapon


func set_current_life(_life: int) -> void:
	statistics.current_life = _life


func get_current_life() -> int:
	return statistics.current_life


func set_is_alive(_is_alive: bool) -> void:
	statistics.is_alive = _is_alive


func get_is_alive() -> bool:
	return statistics.is_alive


func get_runtime_data() -> RuntimeData:
	return _runtime_data
