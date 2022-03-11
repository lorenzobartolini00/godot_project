extends Spatial

class_name Level

func win():
	print("win!")
	GameEvents.emit_signal("win")
