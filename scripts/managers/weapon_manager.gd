extends Manager

class_name WeaponManager


var weapon_list: Array
var current_weapon_index: int


func change_weapon(shift: int) ->void:
	var _current_weapon: Weapon = character.get_current_weapon()
	var _weapon_list: Array = get_weapon_list()
	
	var _current_weapon_index: int
	
	for _weapon in _weapon_list:
		if _weapon.item_reference.name != _current_weapon.name:
			_current_weapon_index += 1
		else:
			break
	
	var next_index: int = (_current_weapon_index + shift) % _weapon_list.size()
	
	_change_current_weapon(_weapon_list[next_index].item_reference)
	GameEvents.emit_signal("weapon_changed", character.get_current_weapon(), character)


func get_weapon_list() -> Array:
	var _weapon_list: Array
	
	var player = character
	if player:
		var inventory: Inventory = player.get_inventory()
		
		var _items: Array = inventory.get_items()
		_weapon_list = _items[Enums.ItemTipology.WEAPON]
		
	return _weapon_list


func drop_weapon() -> void:
	_change_current_weapon(null)


func _change_current_weapon(_new_current_weapon: Weapon):
	character.set_current_weapon(_new_current_weapon)
	GameEvents.emit_signal("ammo_changed", null, character)
	GameEvents.emit_signal("weapon_changed", null, character)
