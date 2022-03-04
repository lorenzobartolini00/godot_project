extends Node

signal setup(statistics)

signal hit(area_hit, damage)
signal collected(object_collected)

signal reload
signal add_item_to_inventory(item, quantity)
signal change_current_weapon(new_weapon)
signal change_current_life(additional_amount, to_max)

signal warning(text)

signal current_life_changed(new_life, character)
signal current_weapon_changed(new_current_weapon, character)
signal current_ammo_changed(new_current_ammo, character)

signal show_weapon_list(weapon_list)

signal inventory_changed(inventory, item_changed)
signal found_new_item(new_item)

signal pause_game
signal resume_game

signal died

func emit_inventory_changed(inventory: Inventory, _item_changed: Dictionary) -> void:
	call_deferred("emit_signal", "inventory_changed", inventory, _item_changed)
