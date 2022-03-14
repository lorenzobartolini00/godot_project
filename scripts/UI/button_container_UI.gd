extends GridContainer

class_name ButtonContainer

export(int) onready var default_x
export(int) onready var default_y

var _columns: int
var _lines: int

onready var _current_button_index: int = default_y*_columns + default_x
onready var buttons: Array = get_children()

export(bool) onready var active


func _ready():
	_columns = self.columns
	_lines = buttons.size() / _columns
	
	GameEvents.connect("button_selected", self, "_on_button_selected")
	
	reset_current_button_index()
	GameEvents.emit_signal("button_selected", buttons[_current_button_index])


func _input(event):
	if active:
		if event is InputEventKey or event is InputEventJoypadButton:
			if event.pressed:
				var button_selected: bool = false
				var _new_row: int = _current_button_index/_columns
				var _new_column: int = _current_button_index%_columns
				
				if Input.is_action_just_pressed("ui_up"):
					_new_row += (_lines - 1)
					button_selected = true
				elif Input.is_action_just_pressed("ui_down"):
					_new_row += 1
					button_selected = true
				
				_new_row %= _lines
				
				if Input.is_action_just_pressed("ui_right"):
					_new_column += (_columns - 1)
					button_selected = true
				elif Input.is_action_just_pressed("ui_left"):
					_new_column += 1
					button_selected = true
				elif Input.is_action_just_pressed("ui_select"):
					GameEvents.emit_signal("button_pressed", buttons[_current_button_index])
				
				_new_column %= _columns
				
				if button_selected:
					
					_current_button_index = _new_row*_columns + _new_column
					
					
					GameEvents.emit_signal("button_selected", buttons[_current_button_index])


func _on_button_selected(button: ButtonUI):
	_current_button_index = buttons.find(button)


func set_active(_active: bool) -> void:
	active = _active
	
	if active:
		reset_current_button_index()
		GameEvents.emit_signal("button_selected", buttons[_current_button_index])


func reset_current_button_index():
	_current_button_index = default_y*_columns + default_x
