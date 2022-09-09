extends Spatial

export(NodePath) onready var character = get_node(character) as Character

onready var progress_bar = $Control/Viewport/ProgressBar
onready var mesh = $Mesh
onready var tween = $Control/Viewport/ProgressBar/Tween


func _ready():
	if GameEvents.connect("current_life_changed", self, "_on_current_life_changed") != OK:
		print("failure")
	if GameEvents.connect("change_controller", self, "_on_controller_changed") != OK:
		print("failure")
	
	progress_bar.max_value = character.current_life.max_life
	progress_bar.value = character.current_life.current_life


func _on_current_life_changed(new_life: Life, _character: Character):
	if _character == character:
		change_progress_bar_value(new_life.current_life)


func change_progress_bar_value(new_value: int):
	tween.interpolate_property(progress_bar, "value",
		progress_bar.value, new_value, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		
	tween.start()


func _on_controller_changed(new_controller, _old_controller) -> void:
	if new_controller == character:
		mesh.visible = false
	elif _old_controller == character:
		mesh.visible = true
