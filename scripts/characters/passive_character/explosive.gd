extends PassiveCharacter

class_name Explosive

export(NodePath) onready var explosion_area = get_node(explosion_area) as Area


func _ready():
	var _shape: Shape = explosion_area.get_child(0).shape
	_shape.radius = get_statistics().current_bomb.radius


#Override
func _on_died(character) -> void:
	._on_died(character)
	
	if character == self:
		spawn_explosion()
		dismount()
		
		self.visible = false
		get_node("CollisionShape").set_deferred("disabled", true)
		
		explode()


func explode() -> void:
	var statistics = self.get_statistics()
	
	if statistics is ExplosiveStatistics:
		var bomb: Bomb = self.get_statistics().current_bomb
		bomb.explode(explosion_area)
