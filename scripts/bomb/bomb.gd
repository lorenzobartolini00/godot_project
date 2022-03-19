extends Stockable

class_name Bomb

export(float) var radius
export(int) var damage = 20


func explode(explosion_area: Area) -> void:
	var overlapping_areas = explosion_area.get_overlapping_areas()

	for area in overlapping_areas:
		area = area as Shootable
		if area:
			GameEvents.emit_signal("hit", area, self.damage)

