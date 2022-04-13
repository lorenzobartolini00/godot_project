extends Navigation


#Debug
var m = SpatialMaterial.new()
var local_path = []


func _ready():
	set_process_input(true)
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white



func _unhandled_input(event):
	if event is InputEventKey and event.scancode == KEY_B:
		draw_path(local_path)



func draw_path(path_array):
	if path_array.size() > 0:
		var im = get_node("Draw")
		im.set_material_override(m)
		im.clear()
		im.begin(Mesh.PRIMITIVE_POINTS, null)
		im.add_vertex(path_array[0])
		im.add_vertex(path_array[path_array.size() - 1])
		im.end()
		im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		for x in path_array:
			im.add_vertex(x)
		im.end()
