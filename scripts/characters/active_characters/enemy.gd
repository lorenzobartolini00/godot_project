extends ActiveCharacter

class_name Enemy

export(NodePath) onready var line_of_sight_raycast = get_node(line_of_sight_raycast) as RayCast
export(NodePath) onready var view_area = get_node(view_area) as Area
export(NodePath) onready var upper_part = get_node(upper_part) as Spatial


export(NodePath) onready var ai_manager = get_node(ai_manager) as AIManager

onready var navigation = get_parent() as Navigation

var velocity: Vector3 = Vector3()


func _ready():
	GameEvents.emit_signal("change_current_weapon", self.get_current_weapon(), self)


func _physics_process(delta):
	
	if _runtime_data.current_ai_state == Enums.AIState.TARGET_AQUIRED:
		shoot_manager.shoot(delta)
	
	if reload_manager.need_reload():
		reload_manager.reload()


#Override
func _on_died(character) -> void:
	if character == self:
		character.set_is_alive(false)
		print(name + " died")
		#Something
		set_damage_area_off()


func get_navigation() -> Navigation:
	return navigation


func get_line_of_sight_raycast() -> RayCast:
	return line_of_sight_raycast


func get_view_area() -> Area:
	return view_area


func get_upper_part() -> Spatial:
	return upper_part
