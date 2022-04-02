extends Navigation


func navigate(character: Character, path: PoolVector3Array, delta) -> PoolVector3Array:
	var direction = Vector3()
	var speed: float = character.get_statistics().move_speed
	var accel: float = character.get_statistics().pathfinding_accel
	
	local_path = path
	
	var step_size: float = speed

	if path.size() > 0:
		
		var destination: Vector3 = path[0]
		destination.y = character.translation.y
		
		direction = destination - character.translation
		
#		print("previous step: " + str(step_size))
		if direction.length() < step_size:
			step_size = direction.length()
			
			path.remove(0)
#		print("next step: " + str(step_size))
		
		character.set_velocity(direction.normalized() * step_size, accel, delta)
		
		direction.y = 0
		if direction:
			var look_at_point = character.translation + direction.normalized()
			var turning_speed: float = character.get_statistics().turning_speed
			
			if character.get_runtime_data().current_ai_state != Enums.AIState.AIMING \
			and character.get_runtime_data().current_ai_state != Enums.AIState.TARGET_AQUIRED:
				character.transform = character.smooth_look_at(character, look_at_point, turning_speed, delta)
			
			if character.get_runtime_data().current_ai_state == Enums.AIState.SEARCHING:
				var upper_part: Spatial = character.get_upper_part()
				
				upper_part.set_as_toplevel(true)
				upper_part.transform = character.smooth_look_at(upper_part, Vector3(look_at_point.x, upper_part.transform.origin.y, look_at_point.z), turning_speed, delta)
				upper_part.set_as_toplevel(false)
			
	return path


func get_points(character: Enemy, target_position: Vector3) -> PoolVector3Array:
	return  get_simple_path(character.translation, target_position)


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
