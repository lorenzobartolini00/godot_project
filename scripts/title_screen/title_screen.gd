extends InteractionTab

class_name TitleScreen

export(NodePath) onready var preview_camera = get_node(preview_camera) as Camera

export var rotation_speed: float = 0.2


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
