extends Resource

class_name Item

export(String) var name
export(Texture) var avatar
export(bool) var is_unique
export(int) var max_quantity
export(Enums.ItemTipology) var tipology

func get_avatar() -> Texture:
	return avatar
