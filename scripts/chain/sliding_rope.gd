extends Chain

class_name SlidingRopeChain

export(NodePath) onready var slider_joint = get_node(slider_joint) as Joint
export(NodePath) onready var slider = get_node(slider) as RigidBody
export(NodePath) onready var remote_transform = get_node(remote_transform) as RemoteTransform

export(int) onready var slider_offset
export(Vector3) onready var slider_vector_offset = Vector3.DOWN


func _ready():
	if GameEvents.connect("activate_slider", self, "_on_activate_slider") != OK:
		print("failure")
	
	setup_from_and_to_position()
	setup_rope()
#	set_all_rigid_body_active(rigid_body_chain)
	
	setup_slider(rigid_body_chain[rigid_body_chain.size() - slider_offset], slider)


func setup_rope() -> void:
	distance = from.transform.origin.distance_to(to.transform.origin)
	number_of_points = distance/chain_element_length
	
	var index: int = 0
	
	var first_rope_element: RigidBody
	first_rope_element = generate_chain(index)
	
	setup_joint_nodes(from_joint, first_rope_element, from)


func setup_slider(target: Node, character: RigidBody):
	slider.transform.origin = from.get_global_transform().origin + slider_vector_offset
	
	slider_joint.transform.origin = from.get_global_transform().origin
	
	slider_joint.look_at(to_position.get_global_transform().origin, Vector3.UP)
	slider_joint.look_at(slider_joint.get_global_transform().origin + -slider_joint.get_global_transform().basis.x, slider_joint.get_global_transform().basis.y)
	slider_joint.set_param(SliderJoint.PARAM_LINEAR_LIMIT_UPPER, distance)
	
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
		GameEvents.emit_signal("activate_slider", body, true)


func _on_activate_slider(character: Character, active: bool):
	if active:
		set_target_to_slider(character)
		set_rigid_body_active(slider, true)
	else:
		set_target_to_slider(null)
