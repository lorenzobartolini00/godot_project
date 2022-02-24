extends Usable

class_name Life

export(int) var current_life
export(int) var max_life


func use(_character):
	GameEvents.emit_signal("change_current_life", self.max_life, false, _character)


func get_current_life() -> int:
	return current_life

func set_current_life(_new_life: int) -> void:
	current_life = _new_life
