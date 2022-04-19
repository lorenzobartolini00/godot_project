extends Door

class_name ScannerDoor

export(String) onready var group_name

#Override
func door_behaviour():
	var colliders = open_area.get_overlapping_bodies()
	var access_granted: bool = false
	
	for collider in colliders:
		if collider.is_in_group(group_name):
			if not is_open:
				GameEvents.emit_signal("lock_door", self, false)
				
			lock_door_timer.stop()
			access_granted = true
			
			break
	
	if not access_granted:
		if lock_door_timer.is_stopped():
			if is_open:
				lock_door_timer.start()
