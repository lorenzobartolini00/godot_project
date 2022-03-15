extends Spatial


func _ready():
	update_collision_mask()


func update_collision_mask():
	var meshes: Array = get_children()
	
	for mesh in meshes:
		var static_body: StaticBody = mesh.get_child(0)
		
		static_body.set_collision_layer_bit(1, true)
