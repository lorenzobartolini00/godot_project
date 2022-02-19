extends Character

class_name Exploadable

export(NodePath) onready var _explosion_area = get_node(_explosion_area) as Area

func _ready():
	var _shape: Shape = _explosion_area.get_child(0).shape
	_shape.radius = statistics.current_weapon.radius
	
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


#func _generate_explosion_area(_radius: float) -> Area:
#	var explosion_area = Area.new()
#	var collision_shape = CollisionShape.new()
#	var shape = SphereShape.new()
#	shape.radius = _radius
#	collision_shape.shape = shape
#	add_child(explosion_area)
#	explosion_area.add_child(collision_shape)
#	explosion_area.monitorable = false
#
#	return explosion_area
