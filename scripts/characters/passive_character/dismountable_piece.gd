extends PassiveCharacter

class_name DismountablePiece

export(Mesh) onready var mesh_reference

export(NodePath) onready var mesh_to_replace = get_node(mesh_to_replace) as MeshInstance
export(NodePath) onready var character_owner = get_node(character_owner) as Character
export(NodePath) onready var attachment = get_node(attachment) as RigidBody

export(NodePath) onready var node_to_move
export(Array, NodePath) onready var remote_transform_to_turn_off
export(NodePath) onready var linked_piece

export(Enums.PieceTipology) onready var piece_tipology
export(bool) onready var use_replace_mesh_reference
export(Vector3) onready var offset

var local_rigidbody: RigidBody = null
var local_joint: Joint = null
var my_priority: int = 1


func _ready():
	if node_to_move:
		node_to_move = get_node(node_to_move) as Node
	if linked_piece:
		linked_piece = get_node(linked_piece) as DismountablePiece
	
	
	if GameEvents.connect("piece_ripped", self, "_on_piece_ripped") != OK:
		print("failure")


func _on_piece_ripped(_character, piece):
	if _character == character_owner:
		if piece == self:
			piece.set_is_alive(false)
			piece.set_damage_area_off()
			piece.delete_mesh_to_replace()
			
			local_rigidbody = generate_piece(my_priority, attachment)
			
			Util.move_node(node_to_move, local_rigidbody, true, node_to_move.get_path())
			
			for remote_transform in remote_transform_to_turn_off:
				remote_transform = get_node(remote_transform) as RemoteTransform
				if remote_transform:
					remote_transform.remote_path =  ""
			
#			if linked_piece:
#				linked_piece.set_priority(my_priority + 1)
#
#				if linked_piece.local_joint:
#					linked_piece.local_joint.set_solver_priority(linked_piece.my_priority)


func _on_died(_character) -> void:
	if _character == self:
		GameEvents.emit_signal("piece_ripped", character_owner, self)
	elif _character == character_owner:
		delete_joint_and_rigidbody()


func generate_piece(priority: int, target: Node) -> RigidBody:
	var joint: PinJoint = PinJoint.new()
	var mesh_instance: MeshInstance = MeshInstance.new()
	var collision_shape: CollisionShape = CollisionShape.new()
	var rigid_body: RigidBody = RigidBody.new()
	
	if use_replace_mesh_reference:
		mesh_instance.mesh = mesh_to_replace.mesh
	else:
		mesh_instance.mesh = mesh_reference
	
	rigid_body.add_child(mesh_instance)
	rigid_body.add_child(collision_shape)
	collision_shape.make_convex_from_brothers()
	
	local_rigidbody = rigid_body
	local_joint = joint
	
	var attachment_position: Vector3 = attachment.global_transform.origin
	var rigid_body_position: Vector3 = attachment_position + offset
	var joint_position: Vector3 = Util.get_point_in_between(attachment_position, rigid_body_position)
	
	Util.add_node_as_child(rigid_body, character_owner.get_parent(), rigid_body_position)
	Util.add_node_as_child(joint, character_owner.get_parent(), joint_position)
	
	rigid_body.set_as_toplevel(true)
	rigid_body.look_at(attachment.global_transform.origin - attachment.global_transform.basis.z, Vector3.UP)
	rigid_body.set_as_toplevel(false)
	
	joint.set_node_a(target.get_path())
	joint.set_node_b(rigid_body.get_path())
	
	joint.set_solver_priority(priority)
	
	return rigid_body


func delete_mesh_to_replace():
	mesh_to_replace.visible = false


func delete_joint_and_rigidbody():
	if local_joint:
		local_joint.queue_free()
	if local_rigidbody:
		local_rigidbody.queue_free()


func get_piece_tipology() -> int:
	return piece_tipology


func set_piece_tipology(type: int) -> void:
	piece_tipology = type


func set_attachment(_attachment: Node) -> void:
	attachment = _attachment


func set_priority(_my_priority: int) -> void:
	my_priority = _my_priority


