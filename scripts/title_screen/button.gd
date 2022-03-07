extends CenterContainer

class_name ButtonUI

export(String) onready var display_name

export(NodePath) onready var display_name_label = get_node(display_name_label) as Label
export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer

export(Enums.ButtonTipology) var tipology

var mouse_entered: bool = false



func _ready():
	get_node("ColorRect").mouse_filter = Control.MOUSE_FILTER_PASS
	display_name_label.text = display_name
	
	GameEvents.connect("button_pressed", self, "_on_button_pressed")
	GameEvents.connect("button_selected", self, "_on_button_selected")


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if mouse_entered:
				GameEvents.emit_signal("button_pressed", self)


func _on_button_pressed(button):
	if button == self:
		match tipology:
			Enums.ButtonTipology.PLAY:
				GameEvents.emit_signal("play", SceneManager.current_level_index)
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


func _on_Button_mouse_entered():
	GameEvents.emit_signal("button_selected", self)
	mouse_entered = true


func _on_Button_mouse_exited():
	mouse_entered = false
