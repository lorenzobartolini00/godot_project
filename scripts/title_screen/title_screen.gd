extends InteractionTab

class_name TitleScreen

export(NodePath) onready var camera_pivot = get_node(camera_pivot) as Spatial
export(NodePath) onready var preview_camera = get_node(preview_camera) as Camera
export(NodePath) onready var viewport = get_node(viewport) as Viewport

export var rotation_speed: float = 0.2


func _ready():
	add_level_to_viewport()
	

func add_level_to_viewport() -> void:
	var level_list_path: Array = Util.list_folder("res://scenes/mockups/")
	var level = load(level_list_path[SceneManager.current_level_index]).instance()
	
	viewport.add_child(level)


func _physics_process(delta):
	camera_pivot.rotation_degrees.y += 180*delta*rotation_speed
	
