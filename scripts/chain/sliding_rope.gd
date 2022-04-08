extends Chain

class_name SlidingRope

export(NodePath) onready var slider_joint = get_node(slider_joint) as Joint
export(NodePath) onready var slider = get_node(slider) as RigidBody
export(NodePath) onready var remote_transform = get_node(remote_transform) as RemoteTransform
export(NodePath) onready var enter_area = get_node(enter_area) as Area

export(int) onready var slider_offset
export(float, 0, 1) onready var jump_off_relative_limit
export(int) onready var initial_slider_position
export(Vector3) onready var offset_from_joint

onready var sliding_character: ActiveCharacter


func _ready():
	if GameEvents.connect("activate_slider", self, "_on_activate_slider") != OK:
		print("failure")
	if GameEvents.connect("stop_sliding", self, "_on_stop_sliding") != OK:
		print("failure")
	
	setup_from_and_to_position()
	setup_rope()
	
	setup_slider(rigid_body_chain[rigid_body_chain.size() - slider_offset], slider)


func _physics_process(_delta):
	if has_slider_reached_end() and sliding_character:
		GameEvents.emit_signal("activate_slider", self, sliding_character, false)
	elif not sliding_character:
		var collider_list: Array = enter_area.get_overlapping_bodies()
		for collider in collider_list:
			if collider is Player:
				var y_velocity: float = collider.velocity.y

				if y_velocity > 0.5:
					GameEvents.emit_signal("activate_slider", self, collider, true)

					break


func setup_rope() -> void:
	chain_length = from.transform.origin.distance_to(to.transform.origin)
	number_of_points = chain_length/chain_element_length
	
	var index: int = 0
	
	var first_rope_element: RigidBody
	first_rope_element = generate_chain(index)
	
	setup_joint_nodes(from_joint, first_rope_element, from)


func setup_slider(target: Node, character: RigidBody):
	var start_node
	
	if initial_slider_position == 0:
		start_node = from
	else:
		var index: int = clamp(initial_slider_position, 0, rigid_body_chain.size() - 1)
		
		index = (rigid_body_chain.size() - 1) - index
		start_node = rigid_body_chain[index]
	
	slider.transform.origin = from.get_global_transform().origin + offset_from_joint
	
	slider_joint.transform.origin = from.get_global_transform().origin
	
	slider_joint.look_at(to_position.get_global_transform().origin, Vector3.UP)
	slider_joint.look_at(slider_joint.get_global_transform().origin + -slider_joint.get_global_transform().basis.x, slider_joint.get_global_transform().basis.y)
	slider_joint.set_param(SliderJoint.PARAM_LINEAR_LIMIT_UPPER, chain_length)
	
	slider.look_at(to.get_global_transform().origin, Vector3.UP)
	slider.look_at(slider.get_global_transform().origin + slider.get_global_transform().basis.z, Vector3.UP)
	
	setup_joint_nodes(slider_joint, target, character)


func set_target_to_slider(node: Node):
	if node:
		remote_transform.remote_path = node.get_path()
	else:
		remote_transform.remote_path = ""


func _on_EnterSlider_body_entered(body):
	if body is Player:
		GameEvents.emit_signal("activate_slider",self, body, true)


func _on_activate_slider(sliding_rope, character: Character, active: bool):
	if sliding_rope == self:
		if active and not sliding_character:
			set_target_to_slider(character)
			set_rigid_body_active(slider, true)
			
			sliding_character = character
			
			slider.linear_velocity = character.velocity
			character.velocity = Vector3(0,0,0)
		else:
			character.velocity = slider.linear_velocity
			set_target_to_slider(null)
			
			sliding_character = null


func _on_stop_sliding(character: ActiveCharacter):
	if character == sliding_character:
		GameEvents.emit_signal("activate_slider", self, character, false)


func has_slider_reached_end() -> bool:
	var slider_position: Vector3 = slider.get_global_transform().origin
	var slider_joint_position: Vector3 = slider_joint.get_global_transform().origin
	
	var distance: float = slider_position.distance_to(slider_joint_position)
	
	return distance > chain_length * jump_off_relative_limit
	
