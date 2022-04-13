extends Node

# warning-ignore:unused_signal
signal setup(statistics)

# warning-ignore:unused_signal
signal hit(area_hit, damage)
# warning-ignore:unused_signal
signal set_damage_area(character, is_disabled)
# warning-ignore:unused_signal
signal collected(object_collected)
# warning-ignore:unused_signal
signal interact(character, interactable_object)

# warning-ignore:unused_signal
signal reload
# warning-ignore:unused_signal
signal add_item_to_inventory(character, item, quantity)
# warning-ignore:unused_signal
signal change_current_weapon(new_weapon)
# warning-ignore:unused_signal
signal change_current_life(additional_amount, to_max)

# warning-ignore:unused_signal
signal warning(text)

# warning-ignore:unused_signal
signal current_life_changed(new_life, character)
# warning-ignore:unused_signal
signal current_weapon_changed(new_current_weapon, character)
# warning-ignore:unused_signal
signal ammo_changed(weapon, character)

# warning-ignore:unused_signal
signal show_weapon_list(weapon_list)

# warning-ignore:unused_signal
signal inventory_changed(inventory, item_changed)
# warning-ignore:unused_signal
signal found_new_item(new_item)

# warning-ignore:unused_signal
signal new_mission(level)

# warning-ignore:unused_signal
signal target_changed(target, character)
# warning-ignore:unused_signal
signal target_acquired(character, target_tipology)
# warning-ignore:unused_signal
signal state_changed(character, new_state)
# warning-ignore:unused_signal
signal character_shot(character)
# warning-ignore:unused_signal
signal piece_ripped(character, piece)

signal change_controller(new_character_controller)

# warning-ignore:unused_signal
signal tab_selected(tab)
# warning-ignore:unused_signal
signal change_tab_to(tab_name)

# warning-ignore:unused_signal
signal dialogue_initiated(slides)
# warning-ignore:unused_signal
signal dialogue_finished

# warning-ignore:unused_signal
signal spawn_enemy(spawner)
# warning-ignore:unused_signal
signal activate_slider(character, active)
# warning-ignore:unused_signal
signal stop_sliding(character)
# warning-ignore:unused_signal
signal died


signal button_selected(button)
# warning-ignore:unused_signal
signal button_pressed(button)

# warning-ignore:unused_signal
signal play
# warning-ignore:unused_signal
signal back
# warning-ignore:unused_signal
signal resume_game
# warning-ignore:unused_signal
signal advance_slide
# warning-ignore:unused_signal
signal title_screen
# warning-ignore:unused_signal
signal exit

# warning-ignore:unused_signal
signal pause_game
# warning-ignore:unused_signal
signal toggle_full_screen

# warning-ignore:unused_signal
signal win

func emit_inventory_changed(inventory: Inventory, _item_changed: Dictionary) -> void:
	call_deferred("emit_signal", "inventory_changed", inventory, _item_changed)

func emit_resume_game() -> void:
	call_deferred("emit_signal", "resume_game")

func emit_button_selected(button) -> void:
	emit_signal("button_selected", button)

func emit_dialog_finished() -> void:
	call_deferred("emit_signal", "dialogue_finished")

func emit_advance_slide() -> void:
	call_deferred("emit_signal", "advance_slide")

func emit_button_pressed(button):
	call_deferred("emit_signal", "button_pressed", button)

func emit_tab_selected(tab):
	call_deferred("emit_signal", "tab_selected", tab)

func emit_spawn_enemy(spawner):
	call_deferred("emit_signal", "spawn_enemy", spawner)

func emit_change_controller(controller: Character):
	call_deferred("emit_signal", "change_controller", controller)
