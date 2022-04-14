extends ItemUI

class_name LifeItemUI

export(NodePath) onready var texture_progress = get_node(texture_progress) as TextureProgress


func _ready():
	if GameEvents.connect("current_life_changed", self, "_on_current_life_changed") != OK:
		print("failure")


func setup(_item: Item, _character: Character):
	if _item is LifeSlot:
		self.local_item = _item
		self.character = _character
	
		texture_progress.texture_progress = _item.progress_bar_texture
		texture_progress.texture_under = _item.under_progress_bar_texture
		
		_update_UI(_character.get_life(), _character)


func _on_current_life_changed(_life: Life, character: Character):
	_update_UI(_life, character)


func _update_UI(_life: Life, _character: Character):
	if _character == character:
		var _current_index: int = 0
		for i in range(get_parent().get_children().size()):
			
			if self == get_parent().get_child(i):
				
				_current_index = i
				break
		
		var inventory: Inventory
		var _life_quantity: int
		
		if character is Player:
			inventory = character.get_inventory()
			_life_quantity = inventory.get_item_quantity(_life)
		elif _character is Enemy:
			_life_quantity = _character.get_life_slot().max_quantity
		
		
		
		var _current_life_index: int = 0
		while _current_life_index < (_life_quantity-1):
			_current_life_index += 1
		
		if _current_index < _current_life_index:
			texture_progress.value = _life.max_life
		
		elif _current_index > _current_life_index:
			texture_progress.value = 0
		
		elif _current_index == _current_life_index:
			texture_progress.value = _life.current_life
		
		texture_progress.max_value = _life.max_life

