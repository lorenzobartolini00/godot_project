extends PassiveCharacter

class_name DismountablePiece

export(Mesh) onready var mesh_reference

export(NodePath) onready var mesh_to_replace = get_node(mesh_to_replace) as MeshInstance
export(NodePath) onready var character = get_node(character) as Character
export(Array, NodePath) onready var linked_pieces

export(Enums.PieceTipology) onready var piece_tipology
export(bool) onready var use_replace_mesh_reference
export(Vector3) onready var offset

var local_rigidbody: RigidBody = null
var local_joint: PinJoint = null


#func _ready():
#	if GameEvents.connect("piece_ripped", self, "_on_piece_ripped") != OK:
#		print("failure")


func _on_died(_character) -> void:
	if _character == self:
		self.set_damage_area_off()
		generate_chain()
		
		delete_mesh_to_replace()
		
	elif _character == character:
		delete_joint_and_rigidbody()


func generate_chain():
	var priority: int = 1
	
	var previous_rigid_body: RigidBody
	previous_rigid_body = generate_piece(priority)
	
	GameEvents.emit_signal("piece_ripped", character, self)
	
	priority += 1
	
	for piece in linked_pieces:
		piece = get_node(piece) as DismountablePiece
		
		#Se il pezzo era già stato rotto, devo eliminare il joint e il rigidbody preesistente per poter formare una catena senza ripetizioni
		piece.delete_joint_and_rigidbody()
		
		#Genero un nuovo elemento della catena, concatenato al primo
		previous_rigid_body = piece.generate_piece(priority, previous_rigid_body)
		
		piece.delete_mesh_to_replace()
		piece.set_is_alive(false)
		
		GameEvents.emit_signal("piece_ripped", piece.character, piece)
		
		priority += 1


func generate_piece(priority: int, previous_rigid_body: RigidBody = null) -> RigidBody:
	var joint: PinJoint = PinJoint.new()
	var mesh_instance: MeshInstance = MeshInstance.new()
	
	if use_replace_mesh_reference:
		mesh_instance.mesh = mesh_to_replace.mesh
	else:
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
	
	var node_a: Node
	
	if previous_rigid_body:
		node_a = previous_rigid_body
	else:
		node_a = character
	
	joint.set_node_a(node_a.get_path())
	joint.set_node_b(rigid_body.get_path())
	
	joint.set_solver_priority(priority)
	
	return rigid_body


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

