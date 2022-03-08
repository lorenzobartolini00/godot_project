extends Stockable

class_name Bomb

export(float) var radius
export(int) var damage = 20


func explode(explosion_area: Area) -> void:
#	#Set explosion radius
#	var _collision_shape: CollisionShape = explosion_area.get_child(0)
#	var _shape: Shape = _collision_shape.shape
#	_shape.radius = self.radius
	
	#Check for collisions
	var overlapping_areas = explosion_area.get_overlapping_areas()

	for area in overlapping_areas:
		area = area as Shootable
		if area:
			GameEvents.emit_signal("hit", area, self.damage)
