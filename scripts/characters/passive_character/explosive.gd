extends PassiveCharacter

class_name Explosive

export(NodePath) onready var _explosion_area = get_node(_explosion_area) as Area

func _ready():
	var _shape: Shape = _explosion_area.get_child(0).shape
#	_shape.radius = statistics.current_weapon.radius


#Override
func _on_died(character) -> void:
	if character == self:
		explode()


func explode() -> void:
	var overlapping_areas = _explosion_area.get_overlapping_areas()

	for area in overlapping_areas:
		area = area as Shootable
		if area:
			GameEvents.emit_signal("hit", area, statistics.current_weapon)

	queue_free()
