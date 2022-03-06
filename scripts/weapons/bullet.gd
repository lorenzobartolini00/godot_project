extends RigidBody

class_name Bullet

export(NodePath) onready var mesh_instance = get_node(mesh_instance) as MeshInstance

var _weapon
var _character

func initialize(start_position: Vector3, character):
	_weapon = character.get_current_weapon()
	_character = character
	
	mesh_instance.mesh = _weapon.get_ammo().get_mesh()
	self.transform.origin = start_position
	
	if _character.is_in_group("player"):
			var camera: Camera = _character.get_camera()
			var raycast: RayCast = _character.get_shooting_raycast()
			
			var screen_center: Vector2 = Vector2(ProjectSettings.get("display/window/size/width")/2, ProjectSettings.get("display/window/size/height")/2)
			var target_point: Vector3 = camera.project_position(screen_center, 100)
			
			var collider = raycast.get_collider()
			
			if collider:
				target_point = collider.get_global_transform().origin
			
			
			self.look_at(target_point, Vector3.UP)
	
	set_as_toplevel(true)


func _physics_process(delta):
	if _weapon:
		var direction: Vector3 = -transform.basis.z.normalized()
		linear_velocity = direction * _weapon.get_ammo().bullet_speed
