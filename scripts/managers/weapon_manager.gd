extends Manager

class_name WeaponManager


var weapon_list: Array
var current_weapon_index: int


func shift_current_weapon(shift: int) ->void:
	var is_freewalk_state = character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK
	
	if is_freewalk_state:
		var _current_weapon: Weapon = character.get_current_weapon()
		var _weapon_list: Array = _get_weapon_list()
		
		var _current_weapon_index: int = 0
		
		for _weapon in _weapon_list:
			if _weapon.item_reference.name != _current_weapon.name:
				_current_weapon_index += 1
			else:
				break
		
		var next_index: int = (_current_weapon_index + shift) % _weapon_list.size()
		
		change_current_weapon(_weapon_list[next_index].item_reference)
	


func _get_weapon_list() -> Array:
	var _weapon_list: Array
	
	var player = character
	if player:
		var inventory: Inventory = player.get_inventory()
		
		var _items: Array = inventory.get_items()
		_weapon_list = _items[Enums.ItemTipology.WEAPON]
		
	return _weapon_list


#func drop_weapon() -> void:
#	character.set_current_weapon(null)
#	GameEvents.emit_signal("ammo_changed", null, character)
#	GameEvents.emit_signal("weapon_changed", null, character)


func change_current_weapon(_new_current_weapon: Weapon):
	character.set_current_weapon(_new_current_weapon)
	GameEvents.emit_signal("current_weapon_changed", character.get_current_weapon(), character)
	
	character.set_current_weapon_mesh(_new_current_weapon.mesh)
	
	if character.is_in_group("player"):
		character.ammo_manager.set_ammo()
