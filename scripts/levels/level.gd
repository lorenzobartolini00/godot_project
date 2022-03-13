extends Spatial

class_name Level

export(Resource) var global_runtime_data = global_runtime_data as RuntimeData





func win():
	print("win!")
	GameEvents.emit_signal("win")
