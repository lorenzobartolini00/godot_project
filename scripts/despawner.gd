extends Node

export(int) var despawn_time = 3

onready var despawn_timer: Timer

func set_up_timer():
	despawn_timer = Timer.new()
	despawn_timer.autostart = true
	despawn_timer.wait_time = despawn_time
	despawn_timer.one_shot = true
	self.add_child(despawn_timer)
	
	despawn_timer.connect("timeout", self, "_on_despawn_timer_timeout")


func set_despawn_time(time: int) -> void:
	despawn_timer.wait_time = time


func start_despawn_timer() -> void:
	despawn_timer.start()


func _on_despawn_timer_timeout():
	queue_free()
