extends Resource

class_name RuntimeData

export(Enums.GamePlayState) var current_gameplay_state

var save_state: Array

func save_current_state():
	save_state.append(current_gameplay_state)

func load_state(index: int):
	current_gameplay_state = save_state[index]
	
func load_last_state():
	current_gameplay_state = save_state[save_state.size() - 1]
