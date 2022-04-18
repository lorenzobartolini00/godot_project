extends Door

class_name ScannerDoor

export(String) onready var group_name

export(float) var close_door_time:= 1.0


var close_door_timer: Timer


func _ready():
	close_door_timer = Util.setup_timer(close_door_timer, self, close_door_time, false, true)
	
	call_deferred("setup_timers")


#Override
func door_behaviour():
	var colliders = open_area.get_overlapping_bodies()
	var access_granted: bool = false
	
	for collider in colliders:
		if collider.is_in_group(group_name):
			if not is_open:
				GameEvents.emit_signal("unlock_door", self)
				
			close_door_timer.stop()
			access_granted = true
			
			break
	
	if not access_granted:
		if close_door_timer.is_stopped():
			if is_open:
				close_door_timer.start()


func on_close_door_timer_timeout():
	GameEvents.emit_signal("unlock_door", self, true)


func setup_timers():
	if close_door_timer.connect("timeout", self, "on_close_door_timer_timeout") != OK:
		print("failure")
