extends CenterContainer

class_name ButtonUI

export(String) onready var display_name

export(NodePath) onready var display_name_label = get_node(display_name_label) as Label
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer

export(Enums.ButtonTipology) var tipology

func _ready():
	display_name_label.text = display_name
	
	GameEvents.connect("button_pressed", self, "_on_button_pressed")
	GameEvents.connect("button_selected", self, "_on_button_selected")


func _on_button_pressed(button):
	if button == self:
		match tipology:
			Enums.ButtonTipology.PLAY:
				GameEvents.emit_signal("play", 0)
			Enums.ButtonTipology.OPTIONS:
				GameEvents.emit_signal("options")
			Enums.ButtonTipology.EXIT:
				GameEvents.emit_signal("exit")


func _on_button_selected(button):
	if button == self:
		animation_player.play("button_selected")
	else:
		animation_player.stop()
		animation_player.play("RESET")