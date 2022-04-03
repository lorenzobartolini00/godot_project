extends PassiveCharacter

class_name DismountablePiece

export(Mesh) onready var mesh_reference

export(NodePath) onready var mesh_to_replace = get_node(mesh_to_replace) as MeshInstance
export(NodePath) onready var character_owner = get_node(character_owner) as Character
export(NodePath) onready var attachment = get_node(attachment) as RigidBody
export(Array, NodePath) onready var node_to_move
export(Array, NodePath) onready var linked_pieces

export(Enums.PieceTipology) onready var piece_tipology
export(bool) onready var use_replace_mesh_reference
export(Vector3) onready var offset

var local_rigidbody: RigidBody = null
var local_joint: PinJoint = null
var my_priority: int = 1
var ripped: bool = false


func _ready():
	var node_list: Array = []
	for node in node_to_move:
		node = get_node(node) as Node
		node_list.append(node)
	
	node_to_move = node_list
	
	if GameEvents.connect("piece_ripped", self, "_on_piece_ripped") != OK:
		print("failure")


func _on_piece_ripped(_character, piece):
	if _character == character_owner:
		if piece == self:
			delete_joint_and_rigidbody()
			piece.set_is_alive(false)
			piece.set_damage_area_off()
			piece.delete_mesh_to_replace()
			
			local_rigidbody = generate_piece(my_priority, attachment)
			ripped = true
			
			Util.move_nodes(node_to_move, local_rigidbody)
			
			generate_chain()


func _on_died(_character) -> void:
	if _character == self:
		GameEvents.emit_signal("piece_ripped", character_owner, self)
	elif _character == character_owner:
		delete_joint_and_rigidbody()


func generate_chain():
	for piece in linked_pieces:
		piece = get_node(piece) as DismountablePiece
		
		piece.set_attachment(local_rigidbody)
		piece.set_priority(my_priority + 1)
		
		GameEvents.emit_signal("piece_ripped", piece.character_owner, piece)


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
	
	Util.add_node_as_child(joint, character_owner.get_parent(), self.get_global_transform().origin)
	Util.add_node_as_child(rigid_body, character_owner.get_parent(), self.get_global_transform().origin + offset)
	
	rigid_body.transform = self.get_global_transform()
	
	joint.set_node_a(target.get_path())
	joint.set_node_b(rigid_body.get_path())
	
	joint.set_solver_priority(priority)
	
	return rigid_body


#func retarget_joint():
#	local_joint.set_node_a(attachment.get_path())
#	pass


func delete_joint_and_rigidbody():
	if local_joint:
			local_joint.queue_free()
	if local_rigidbody:
		local_rigidbody.queue_free()


func delete_mesh_to_replace():
	mesh_to_replace.visible = false


func get_piece_tipology() -> int:
	return piece_tipology


func set_piece_tipology(type: int) -> void:
	piece_tipology = type


func set_attachment(_attachment: Node) -> void:
	attachment = _attachment


func set_priority(_my_priority: int) -> void:
	my_priority = _my_priority




