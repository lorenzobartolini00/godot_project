extends Area

class_name Shootable

export(NodePath) onready var character = get_node(character) as Character


func _get_configuration_warning() -> String:
	character = get_parent()
	if not character:
		return "Must be placed as a direct child of a Character Node!"
	else:
		return ""


func _ready():
	if GameEvents.connect("set_damage_area", self, "_on_set_damage_area") != OK:
		print("failure")
	
	if GameEvents.connect("hit", self, "_on_hit") != OK:
		print("failure")


func _on_hit(area_hit: Shootable, damage: int) -> void:
	if area_hit == self:
		GameEvents.emit_signal("change_current_life", -damage, false, character)
		
		character.sound_manager.play_on_character_stream_player("hit")


func _on_set_damage_area(_character, is_disabled: bool):
	if _character == character:
		var collision_shape = self.get_child(0) as CollisionShape
		if collision_shape:
			collision_shape.set_deferred("disabled", is_disabled)
		else:
			print("no collision shape found")
