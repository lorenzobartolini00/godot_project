extends Item

class_name Life

export(int) var current_life
export(int) var max_life

func get_current_life() -> int:
	return current_life

func set_current_life(_new_life: int) -> void:
	current_life = _new_life
