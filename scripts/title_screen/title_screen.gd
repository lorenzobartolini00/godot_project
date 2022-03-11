extends Tab

class_name TitleScreen

export(NodePath) onready var camera_pivot = get_node(camera_pivot) as Spatial
export(NodePath) onready var preview_camera = get_node(preview_camera) as Camera


export var rotation_speed: float = 0.2


func _ready():
	GameEvents.emit_signal("tab_selected", self)
	add_to_stack()


func _physics_process(delta):
	camera_pivot.rotation_degrees.y += 180*delta*rotation_speed
	
