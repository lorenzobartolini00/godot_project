extends Interactable

class_name Switch

signal switch_pressed

export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer


func _on_interact(character: Character, interactable_object):
	if not is_used:
		if interactable_object == self and is_active:
			emit_signal("switch_pressed", self)
			set_is_used(true)
			
			animation_player.play("push")
			play_interaction_sound()
