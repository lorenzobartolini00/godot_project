extends Door

class_name ScannerDoor

export(String) onready var group_name
export(NodePath) onready var open_area_alt = get_node(open_area_alt) as Area

#Override
func door_behaviour():
	var colliders_1 = open_area.get_overlapping_bodies()
	var colliders_2 = open_area_alt.get_overlapping_bodies()
	var colliders_list = [colliders_1, colliders_2]
	
	var access_granted: bool = false
	
	for colliders in colliders_list:
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
