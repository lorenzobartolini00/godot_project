extends Door

class_name ShootDoor


func door_behaviour():
	if is_open and not keep_opened:
		if lock_door_timer.is_stopped():
			lock_door_timer.start()


func on_close_door_timer_timeout():
	if not keep_opened:
		var colliders: Array = open_area.get_overlapping_bodies()
		
		if colliders.size() > 0:
			lock_door_timer.start()
		else:
			GameEvents.emit_signal("lock_door", self, true)
	else:
		lock_door_timer.stop()
