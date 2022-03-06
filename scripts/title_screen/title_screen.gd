extends Control

class_name TitleScreen

export(NodePath) onready var camera_pivot = get_node(camera_pivot) as Spatial
export(NodePath) onready var preview_camera = get_node(preview_camera) as Camera
export(NodePath) onready var button_container = get_node(button_container) as VBoxContainer


export var rotation_speed: float = 0.2

onready var _current_button_index: int = 0

func _ready():
	var buttons: Array = button_container.get_children()
	GameEvents.emit_signal("button_selected", buttons[_current_button_index])


func _physics_process(delta):
	camera_pivot.rotation_degrees.y += 180*delta*rotation_speed


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			var buttons: Array = button_container.get_children()
			
			if Input.is_action_just_pressed("ui_up"):
				_current_button_index -= 1
			elif Input.is_action_just_pressed("ui_down"):
				_current_button_index += 1
			elif Input.is_action_just_pressed("ui_select"):
				GameEvents.emit_signal("button_pressed", buttons[_current_button_index])
			
			
			_current_button_index %= (buttons.size())
			GameEvents.emit_signal("button_selected", buttons[_current_button_index])
