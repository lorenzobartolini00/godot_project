extends Interactable

class_name Console

export(NodePath) onready var spawner = get_node(spawner) as Spawner
export(float) var interact_time:= 5.0

var interact_timer: Timer

func _ready():
	interact_timer = Util.setup_timer(interact_timer, self, interact_time)
	
	call_deferred("setup_timers")


func _on_interact(character: Character, interactable_object):
	if interactable_object == self:
		if not is_used:
			var spawned_enemy: Enemy = spawner.spawn()
			
			if spawned_enemy:
				set_is_used(true)
				interact_timer.start()
				
				GameEvents.emit_change_controller(spawned_enemy, character)
			else:
				GameEvents.emit_signal("warning", "Can't spawn right now...")
		else:
			GameEvents.emit_signal("warning", "Cooling down...")


func setup_timers():
	if interact_timer.connect("timeout", self, "_on_interact_timer_timeout") != OK:
		print("failure")


func _on_interact_timer_timeout():
	set_is_used(false)
