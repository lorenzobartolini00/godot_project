extends Area

class_name MortalZone


func _physics_process(delta):
	var colliders = self.get_overlapping_bodies()
	
	for collider in colliders:
		if collider is ActiveCharacter:
			GameEvents.emit_signal("died", collider)
