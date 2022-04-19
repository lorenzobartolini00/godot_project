extends Shootable

class_name ShootableDoorTarget


func _on_hit(area_hit: Shootable, _damage: int) -> void:
	if area_hit == self:
		var door: Door = character.get_door()
		
		GameEvents.emit_signal("lock_door", door, false)
		
		character.sound_manager.play_on_character_stream_player("hit")
