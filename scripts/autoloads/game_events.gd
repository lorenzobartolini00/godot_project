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

signal target_changed(target)
signal target_acquired(character, target_tipology)

signal pause_game
signal resume_game

signal dialogue_initiated(slides)
signal dialogue_finished

signal died

signal button_selected(button)
signal button_pressed(button)

signal play
signal options
signal exit

func emit_inventory_changed(inventory: Inventory, _item_changed: Dictionary) -> void:
	call_deferred("emit_signal", "inventory_changed", inventory, _item_changed)

#func emit_add_item_to_inventory(item: Item, quantity: int) -> void:
#	emit_signal("add_item_to_inventory", item, quantity)

func emit_dialog_finished() -> void:
	call_deferred("emit_signal", "dialogue_finished")
