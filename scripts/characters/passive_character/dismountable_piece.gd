extends PassiveCharacter

class_name DismountablePiece

export(Mesh) onready var mesh_reference

export(NodePath) onready var mesh_to_replace = get_node(mesh_to_replace) as MeshInstance
export(NodePath) onready var character = get_node(character) as Character
#export(NodePath) onready var joint_position = get_node(joint_position) as Position3D
#export(NodePath) onready var piece_position = get_node(piece_position) as Position3D
export(Vector3) onready var offset

var local_rigidbody: RigidBody = null
var local_joint: PinJoint = null


func generate_piece():
	var joint: PinJoint = PinJoint.new()
	
	var mesh_instance: MeshInstance = MeshInstance.new()
	mesh_instance.mesh = mesh_reference
	
	var collision_shape: CollisionShape = CollisionShape.new()
	collision_shape.shape = SphereShape.new()
	collision_shape.shape.radius = 0.8
	
	var rigid_body: RigidBody = RigidBody.new()
	rigid_body.add_child(mesh_instance)
	rigid_body.add_child(collision_shape)
	
	local_rigidbody = rigid_body
	local_joint = joint
	
	Util.add_node_to_scene(joint, self.get_global_transform().origin)
	Util.add_node_to_scene(rigid_body, self.get_global_transform().origin + offset)
	
	joint.set_node_a(character.get_path())
	joint.set_node_b(rigid_body.get_path())


func _on_died(_character) -> void:
	if _character == self:
		self.set_damage_area_off()
		generate_piece()
		
		mesh_to_replace.queue_free()
	elif _character == character:
		if local_joint:
			local_joint.queue_free()
		if local_rigidbody:
			local_rigidbody.queue_free()


