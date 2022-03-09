extends Statistics

class_name ActiveCharacterStatistics

export(float) var move_speed:= 3
export(float) var turning_speed:= 3
export(float) var aim_speed:= 1
export(float) var max_view_distance:= 60
export(float) var max_alert_distance:= 10
export(float) var max_distance_tollerance:= 1.0	#distanza al di sotto della quale due punti sono considerati coincidenti
export(float) var lost_target_time:= 60
export(float) var reload_time
export(Resource) var current_weapon = current_weapon as Weapon
export(Array, AudioStream) var idle_sounds
