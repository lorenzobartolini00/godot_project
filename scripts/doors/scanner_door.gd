extends Door

class_name ScannerDoor

export(String) onready var group_name
export(NodePath) onready var open_area_2 = get_node(open_area_2) as Area

#Override
func door_behaviour():
	var collider_list: Array = open_area.get_overlapping_bodies()
	collider_list.append_array(open_area_2.get_overlapping_bodies())
	
	var access_granted: bool = false
	
	for collider in collider_list:
		#Se la porta è bloccata e qualcuno nell'area è autorizzato,
		#sblocca la porta.
		if collider.is_in_group(group_name):
			if not is_open:
				GameEvents.emit_signal("lock_door", self, false)

			lock_door_timer.stop()
			access_granted = true
			
			break
	
	
	#Fai ripartire il timer per bloccare la porta se è scaduto e la porta è sbloccata
	if not access_granted:
		if lock_door_timer.is_stopped():
			if is_open:
				lock_door_timer.start()
