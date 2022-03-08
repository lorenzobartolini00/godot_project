extends ActiveCharacter

class_name Enemy

export(NodePath) onready var ai_raycasts = get_node(ai_raycasts) as Spatial

export(NodePath) onready var ai_manager = get_node(ai_manager) as AIManager

onready var navigation = get_parent() as Navigation

var velocity: Vector3 = Vector3()

func _ready():
	GameEvents.emit_signal("change_current_weapon", self.get_current_weapon(), self)


func _physics_process(delta):
	ai_raycasts.rotation_degrees.y += 180*delta
	
	if _runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED:
		shoot_manager.shoot(delta)
	
	if reload_manager.need_reload():
		reload_manager.reload()


#Override
func _on_died(character) -> void:
	if character == self:
		print(name + " died")
		#Something
		queue_free()


func get_navigation() -> Navigation:
	return navigation


func get_ai_raycasts() -> Array:
	return ai_raycasts.get_children()
