extends GridContainer

class_name ButtonContainer

export(int) onready var default_x = 0
export(int) onready var default_y = 0

var _columns: int
var _lines: int

onready var _current_column: int = default_x
onready var _current_line: int = default_y
onready var _current_button_index: int = _current_line*_columns + _current_column
onready var buttons: Array = get_children()

export(bool) onready var active

func _ready():
	_columns = self.columns
	_lines = buttons.size() / _columns


func _input(event):
	if active:
		if event is InputEventKey:
			if event.pressed:
				var button_selected: bool = false
				
				if Input.is_action_just_pressed("ui_up"):
					_current_line += (_lines - 1)
					button_selected = true
				elif Input.is_action_just_pressed("ui_down"):
					_current_line += 1
					button_selected = true
				if Input.is_action_just_pressed("ui_right"):
					_current_column += (_columns - 1)
					button_selected = true
				elif Input.is_action_just_pressed("ui_left"):
					_current_column += 1
					button_selected = true
				elif Input.is_action_just_pressed("ui_select"):
					GameEvents.emit_signal("button_pressed", buttons[_current_button_index])
				
				if button_selected:
					_current_column %= _columns
					_current_line %= _lines
					
					_current_button_index = _current_line*_columns + _current_column
					
					GameEvents.emit_signal("button_selected", buttons[_current_button_index])


func _on_button_selected(button: ButtonUI):
	_current_button_index = buttons.find(button)


func set_active(_active: bool) -> void:
	active = _active
	if active:
		GameEvents.emit_signal("button_selected", buttons[_current_button_index])
