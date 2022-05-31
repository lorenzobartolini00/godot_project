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
	
	if GameEvents.connect("button_pressed", self, "_on_button_pressed") != OK:
		print("failure")
	if GameEvents.connect("button_selected", self, "_on_button_selected") != OK:
		print("failure")


func _process(_delta):
	if get_parent().active:
		if Input.is_action_just_released("shoot"):
			if mouse_entered:
				GameEvents.emit_signal("button_pressed", self)


func _on_button_pressed(button):
	if button == self:
		match tipology:
			Enums.ButtonTipology.PLAY:
				GameEvents.emit_signal("play", SceneManager.current_level_index)
			Enums.ButtonTipology.OPTIONS:
				GameEvents.emit_signal("change_tab_to", "options")
			Enums.ButtonTipology.COMAND_LIST:
				GameEvents.emit_signal("change_tab_to", "comand_list")
			Enums.ButtonTipology.AUDIO_SETTINGS:
				GameEvents.emit_signal("change_tab_to", "audio_settings")
			Enums.ButtonTipology.PLAY_SETTINGS:
				GameEvents.emit_signal("change_tab_to", "play_settings")
			Enums.ButtonTipology.BACK:
				GameEvents.emit_signal("back")
			Enums.ButtonTipology.ADVANCE_SLIDE:
				GameEvents.emit_signal("advance_slide")
			Enums.ButtonTipology.TOGGLE_FULL_SCREEN:
				GameEvents.emit_signal("toggle_full_screen")
			Enums.ButtonTipology.TITLE_SCREEN:
				GameEvents.emit_signal("title_screen")
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
