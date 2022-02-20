extends Node

signal setup(statistics)

signal hit(area_hit, damage)
signal collected(object_collected)
signal found_new_item(new_item)

signal reload
signal warning(text)
signal life_changed(new_life, character)
signal weapon_changed(new_weapon, character)
signal ammo_changed(new_ammo, character)

signal show_weapon_list(weapon_list)

signal inventory_changed(inventory)

signal died
