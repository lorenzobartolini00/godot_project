extends Tab

class_name OptionTab

export(String) onready var tab_name

export(Enums.OptionTab) onready var option_tab_tipology


func _ready():
	name_label.text = tab_name
	
	
	runtime_data.current_gameplay_state = Enums.GamePlayState.OPTIONS
	GameEvents.emit_signal("pause_game")
	GameEvents.emit_signal("tab_selected", self)



