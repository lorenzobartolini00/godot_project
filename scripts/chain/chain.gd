extends Spatial

class_name Chain

export(NodePath) onready var from_position = get_node(from_position) as Position3D
export(NodePath) onready var to_position = get_node(to_position) as Position3D
export(NodePath) onready var from = get_node(from) as RigidBody
export(NodePath) onready var to = get_node(to) as RigidBody
export(NodePath) onready var from_joint = get_node(from_joint) as Joint

export(float, 0, 5) onready var softness
export(float, 0, 5) onready var damping
export(float, 0, 5) onready var restitution
export(float) onready var chain_element_length: float

export(PackedScene) onready var chain_element_reference

var number_of_points: int
var distance: float

onready var rigid_body_chain: Array = []


func generate_chain(index: int) -> RigidBody:
	var target: RigidBody
	
	if index == number_of_points:
		return to
	else:
		index += 1
		
		target = generate_chain(index)
		var rope_element: RigidBody
		
		rope_element = generate_element(target, index)
		rigid_body_chain.append(rope_element)
		
		return rope_element


func generate_element(target: RigidBody, index: int) -> RigidBody:
	var joint: Generic6DOFJoint = Generic6DOFJoint.new()
	var rope_element: RigidBody = chain_element_reference.instance()
	
	var rope_element_position: Vector3 = get_chain_element_position(index)
	
	add_child(rope_element)
	add_child(joint)
	
	rope_element.transform.origin = rope_element_position
	rope_element.look_at(target.get_global_transform().origin, Vector3.UP)
	joint.transform.origin = Util.get_point_in_between(rope_element_position, target.get_global_transform().origin)
	setup_joint_nodes(joint, rope_element, target)
	
	return rope_element


func get_chain_element_position(index: int) -> Vector3:
	var from_position_vector: Vector3 = from.get_global_transform().origin
	var to_position_vector: Vector3 = to.get_global_transform().origin
	var direction: Vector3 = (to_position_vector - from_position_vector).normalized()
	var distance_between_points: float = distance/(number_of_points+1)
	
	return from_position_vector + direction * distance_between_points * index


func setup_joint_nodes(joint: Joint, node_a: Node, node_b: Node) -> void:
	joint.set_node_a(node_a.get_path())
	joint.set_node_b(node_b.get_path())
	
	if joint is Generic6DOFJoint:
		set_all_joint_parameters(joint)


func setup_from_and_to_position():
	from.transform.origin = from_position.get_global_transform().origin
	from_joint.transform.origin = from_position.get_global_transform().origin
	to.transform.origin = to_position.get_global_transform().origin


func set_all_rigid_body_active(rigid_body_list: Array, active: bool = true) -> void:
	for rigid_body in rigid_body_list:
		set_rigid_body_active(rigid_body, active)


func set_rigid_body_active(rigid_body: RigidBody, active: bool = true):
	if active:
		rigid_body.mode = RigidBody.MODE_RIGID
	else:
		rigid_body.mode = RigidBody.MODE_STATIC


func set_all_joint_parameters(joint: Joint) -> void:
	set_joint_parameter(joint, Generic6DOFJoint.PARAM_LINEAR_LIMIT_SOFTNESS, softness)
	set_joint_parameter(joint, Generic6DOFJoint.PARAM_ANGULAR_LIMIT_SOFTNESS, softness)
	set_joint_parameter(joint, Generic6DOFJoint.PARAM_LINEAR_DAMPING, damping)
	set_joint_parameter(joint, Generic6DOFJoint.PARAM_ANGULAR_DAMPING, damping)
	set_joint_parameter(joint, Generic6DOFJoint.PARAM_LINEAR_RESTITUTION, restitution)
	set_joint_parameter(joint, Generic6DOFJoint.PARAM_ANGULAR_RESTITUTION, restitution)


func set_joint_parameter(joint: Joint, param: int, value: float):
	joint.set_param_x(param, value)
	joint.set_param_y(param, value)
	joint.set_param_z(param, value)
