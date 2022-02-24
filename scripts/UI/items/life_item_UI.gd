extends ItemUI

class_name LifeItemUI

export(NodePath) onready var texture_progress = get_node(texture_progress) as TextureProgress


func _ready():
	GameEvents.connect("current_life_changed", self, "_on_current_life_changed")


func setup(_item: Item, _inventory: Inventory):
	if _item is LifeSlot:
		self.inventory = _inventory


func _on_current_life_changed(_life: Life, character: Character):
	_update_UI(_life, character)


func _update_UI(_life: Life, character: Character):
	if character.is_in_group("player"):
		var _current_index: int = 0
		for i in range(get_parent().get_children().size()):
			
			if self == get_parent().get_child(i):
				
				_current_index = i
				break
		
		var _life_quantity = self.inventory.get_item_quantity(_life)
		
		var _current_life_index: int = 0
		while _current_life_index < _life_quantity:
			_current_life_index += 1
		
		if _current_index < _current_life_index:
			texture_progress.value = _life.max_life
		
		elif _current_index > _current_life_index:
			texture_progress.value = 0
		
		elif _current_index == _current_life_index:
			texture_progress.value = _life.current_life
		
		texture_progress.max_value = _life.max_life

