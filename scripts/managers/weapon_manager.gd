extends Manager

class_name WeaponManager


var weapon_list: Array
var current_weapon_index: int

func _ready():
	GameEvents.connect("change_current_weapon", self, "_on_change_current_weapon")


func _on_change_current_weapon(_new_weapon: Weapon, _character):
	if _character == character:
		#La chiamata alla funzione è rimandata per permettere all'inventario di aggiornarsi
		call_deferred("change_current_weapon", _new_weapon)


func shift_current_weapon(shift: int) ->void:
	if character.is_in_group("player"):
		var is_freewalk_state = character.get_runtime_data().current_gameplay_state == Enums.GamePlayState.FREEWALK
		
		if is_freewalk_state:
			var _current_weapon: Weapon = character.get_current_weapon()
			
			var _inventory: Inventory = character.get_inventory()
			var _weapon_list: Array = _inventory.get_item_list(Enums.ItemTipology.WEAPON)
			
			var _current_weapon_index: int = 0
			
			for _weapon in _weapon_list:
				if _weapon.item_reference.name != _current_weapon.name:
					_current_weapon_index += 1
				else:
					break
			
			var next_index: int = (_current_weapon_index + shift) % _weapon_list.size()
			
			change_current_weapon(_weapon_list[next_index].item_reference)


func change_current_weapon(_new_current_weapon: Weapon):
	character.set_current_weapon(_new_current_weapon)
	GameEvents.emit_signal("current_weapon_changed", character.get_current_weapon(), character)
	
	character.set_current_weapon_mesh(_new_current_weapon.mesh)
	
	if character.is_in_group("player"):
		character.ammo_manager.set_ammo_for_weapon(_new_current_weapon)
	
	#Setta la distanza dello shooting_raycast
	var shooting_raycast = character.get_shooting_raycast() as RayCast
	shooting_raycast.cast_to = Vector3(0, 0, -_new_current_weapon.max_distance)
