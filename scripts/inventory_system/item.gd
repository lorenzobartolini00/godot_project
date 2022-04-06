extends Resource

class_name Item

export(String) var name
export(String) var display_name = name
export(Texture) var avatar
export(Resource) var description = preload("res://my_resources/slides/no_description.tres") as Slide
export(Mesh) var display_mesh
export(bool) var is_unique
export(int) var max_quantity
export(Enums.ItemTipology) var tipology


func get_avatar() -> Texture:
	return avatar


func get_mesh() -> Mesh:
	return display_mesh
