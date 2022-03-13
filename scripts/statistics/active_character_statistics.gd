extends Statistics

class_name ActiveCharacterStatistics

export(float) var move_speed:= 3
export(float) var turning_speed:= 3
export(float) var aim_speed:= 1
export(float) var max_view_distance:= 60
export(float) var max_alert_distance:= 10
export(float) var max_distance_tollerance:= 1.0	#distanza al di sotto della quale due punti sono considerati coincidenti
export(float) var lost_target_time:= 60
export(float) var max_hear_distance:= 30
#export(float) var reload_time
export(Resource) var current_weapon = current_weapon as Weapon
#Array di due dimensioni: la prima dimensione sono le tipologie di suono che il character deve emettere quando passa in uno degli stati
#elencati in Enums.AIState. La seconda dimensione contiene delle varianti del suono stesso(Es: laugh1, laugh2, ...)
export(Array, Array, AudioStream) var sound_list
export(String, MULTILINE) var die_text = "You have died"
