extends ActiveCharacterStatistics

class_name EnemyStatistics


export(float) var pathfinding_accel:= 10
export(float) var keep_distance_accel:= 5
export(float) var brake_accel:= 20
export(float) var max_view_distance:= 60
export(float) var max_alert_distance:= 10
export(float) var max_distance_tollerance:= 1.0	#distanza al di sotto della quale due punti sono considerati coincidenti
export(float) var lost_target_time:= 60
export(float) var max_hear_distance:= 30
export(float) var min_distance:= 5
#Array di due dimensioni: la prima dimensione sono le tipologie di suono che il character deve emettere quando passa in uno degli stati
#elencati in Enums.AIState. La seconda dimensione contiene delle varianti del suono stesso(Es: laugh1, laugh2, ...)
export(Array, Array, AudioStream) var ai_sound_list
