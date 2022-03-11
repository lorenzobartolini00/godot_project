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

signal target_changed(target, character)
signal target_acquired(character, target_tipology)
signal state_changed(character, new_state)

signal tab_selected(tab)

signal dialogue_initiated(slides)
signal dialogue_finished

signal died

signal button_selected(button)
signal button_pressed(button)

signal play
signal options
signal back
signal resume_game
signal advance_slide
signal exit

signal pause_game

func emit_inventory_changed(inventory: Inventory, _item_changed: Dictionary) -> void:
	call_deferred("emit_signal", "inventory_changed", inventory, _item_changed)

func emit_resume_game() -> void:
	call_deferred("emit_signal", "resume_game")

func emit_button_selected(button: ButtonUI) -> void:
	emit_signal("button_selected", button)

func emit_dialog_finished() -> void:
	call_deferred("emit_signal", "dialogue_finished")

func emit_advance_slide() -> void:
	call_deferred("emit_signal", "advance_slide")

func emit_button_pressed(button: ButtonUI):
	call_deferred("emit_signal", "button_pressed", button)

func emit_tab_selected(tab: Tab):
	call_deferred("emit_signal", "tab_selected", tab)
