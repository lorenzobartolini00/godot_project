extends Node

signal setup(statistics)

signal hit(area_hit, damage)
signal collected(object_collected)

signal reload
signal life_changed(new_life, character)
signal weapon_changed(new_weapon, character)
signal ammo_changed(new_ammo, character)

signal inventory_changed(inventory)

signal died
