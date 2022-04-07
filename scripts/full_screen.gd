extends Node

func _ready():
	if GameEvents.connect("toggle_full_screen", self, "_on_toggle_full_screen") != OK:
		print("failure")
	

func _on_toggle_full_screen():
	OS.window_fullscreen = !OS.window_fullscreen
