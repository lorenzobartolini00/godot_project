extends Spatial

class_name SlidingRope

export(NodePath) onready var from_position = get_node(from_position) as Position3D
export(NodePath) onready var to_position = get_node(to_position) as Position3D
export(NodePath) onready var from = get_node(from) as RigidBody
export(NodePath) onready var to = get_node(to) as RigidBody
export(NodePath) onready var from_joint = get_node(from_joint) as Joint

export(float, 0, 5) onready var softness
export(float, 0, 5) onready var damping
export(float, 0, 5) onready var restitution
export(float) onready var element_length: float


export(PackedScene) onready var rope_element_reference

var number_of_points: int
var distance: float

onready var rigid_body_chain: Array = []


func _ready():
	setup_point_position()
	setup_rope()
	set_rigid_body_active()


func setup_point_position():
	from.transform.origin = from_position.get_global_transform().origin
	from_joint.transform.origin = from_position.get_global_transform().origin
	to.transform.origin = to_position.get_global_transform().origin


func setup_rope() -> void:
	distance = from.transform.origin.distance_to(to.transform.origin)
	number_of_points = distance/element_length
	
	var index: int = 0
	
	var first_rope_element: RigidBody
	first_rope_element = generate_chain(index)
	
	set_joint_nodes(from_joint, first_rope_element, from)


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
	var rope_element: RigidBody = rope_element_reference.instance()
	
	var rope_element_position: Vector3 = get_element_position(index)
	
	add_child(rope_element)
	add_child(joint)
	
	rope_element.transform.origin = rope_element_position
	rope_element.look_at(target.get_global_transform().origin, Vector3.UP)
	joint.transform.origin = get_point_in_between(rope_element_position, target.get_global_transform().origin)
	set_joint_nodes(joint, rope_element, target)
	
	return rope_element


func get_element_position(index: int) -> Vector3:
	var from_position_vector: Vector3 = from.get_global_transform().origin
	var to_position_vector: Vector3 = to.get_global_transform().origin
	var direction: Vector3 = (to_position_vector - from_position_vector).normalized()
	var distance_between_points: float = distance/(number_of_points+1)
	
	return from_position_vector + direction * distance_between_points * index


func set_joint_nodes(joint: Joint, node_a: Node, node_b: Node) -> void:
	joint.set_node_a(node_a.get_path())
	joint.set_node_b(node_b.get_path())
	
	set_joint_param(joint)


func set_joint_param(joint: Joint) -> void:
	joint.set_param_x(Generic6DOFJoint.PARAM_LINEAR_LIMIT_SOFTNESS, softness)
	joint.set_param_y(Generic6DOFJoint.PARAM_LINEAR_LIMIT_SOFTNESS, softness)
	joint.set_param_z(Generic6DOFJoint.PARAM_LINEAR_LIMIT_SOFTNESS, softness)
	joint.set_param_x(Generic6DOFJoint.PARAM_ANGULAR_LIMIT_SOFTNESS, softness)
	joint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_LIMIT_SOFTNESS, softness)
	joint.set_param_z(Generic6DOFJoint.PARAM_ANGULAR_LIMIT_SOFTNESS, softness)
	
	joint.set_param_x(Generic6DOFJoint.PARAM_LINEAR_DAMPING, damping)
	joint.set_param_y(Generic6DOFJoint.PARAM_LINEAR_DAMPING, damping)
	joint.set_param_z(Generic6DOFJoint.PARAM_LINEAR_DAMPING, damping)
	joint.set_param_x(Generic6DOFJoint.PARAM_ANGULAR_DAMPING, damping)
	joint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_DAMPING, damping)
	joint.set_param_z(Generic6DOFJoint.PARAM_ANGULAR_DAMPING, damping)
	
	joint.set_param_x(Generic6DOFJoint.PARAM_LINEAR_RESTITUTION, restitution)
	joint.set_param_y(Generic6DOFJoint.PARAM_LINEAR_RESTITUTION, restitution)
	joint.set_param_z(Generic6DOFJoint.PARAM_LINEAR_RESTITUTION, restitution)
	joint.set_param_x(Generic6DOFJoint.PARAM_ANGULAR_RESTITUTION, restitution)
	joint.set_param_y(Generic6DOFJoint.PARAM_ANGULAR_RESTITUTION, restitution)
	joint.set_param_z(Generic6DOFJoint.PARAM_ANGULAR_RESTITUTION, restitution)
	


func get_point_in_between(point_a: Vector3, point_b: Vector3, relative: float = 0.5) -> Vector3:
	var distance_vector: Vector3 = point_b - point_a
	var point_in_between: Vector3 = point_a + distance_vector * relative
	
	return point_in_between


func set_rigid_body_active() -> void:
	for rigid_body in rigid_body_chain:
		rigid_body.mode = RigidBody.MODE_RIGID
