extends ActiveCharacterStatistics

class_name EnemyStatistics


export(float) var pathfinding_accel:= 10.0
export(float) var keep_distance_accel:= 5.0
export(float) var brake_accel:= 20.0
export(float) var max_view_distance:= 60.0
export(float) var max_alert_distance:= 10.0
export(float) var max_distance_tollerance:= 1.0	#distanza al di sotto della quale due punti sono considerati coincidenti
export(float) var lost_target_time:= 60.0
export(float) var idle_path_time:= 5.0
export(float) var speak_time:= 5.0
export(float) var max_hear_distance:= 30.0
export(float) var max_distance_from_final_location:= 3.0
export(float) var min_distance:= 5.0
export(float) var update_path_time:= 3.0
export(float) var update_random_path_time:= 7.0
export(float) var idle_point_radius:= 20.0
export(float) var small_random_point_radius:= 2.0
export(float) var big_random_point_radius:= 4.0
export(float) var wait_to_shoot_time:= 1.5
export(float, 0, 1) var unable_to_fight_threshold:= 0.2
#Array di due dimensioni: la prima dimensione sono le tipologie di suono che il character deve emettere quando passa in uno degli stati
#elencati in Enums.AIState. La seconda dimensione contiene delle varianti del suono stesso(Es: laugh1, laugh2, ...)
export(Dictionary) var ai_sound_list = {
	"start" : [],
	"idle" : [preload("res://assets/my_assets/sounds/carl_dialogues/idle_1.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/idle_2.wav")],
	"aiming" : [preload("res://assets/my_assets/sounds/carl_dialogues/aiming_1.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/aiming_2.wav")],
	"target_acquired" : [preload("res://assets/my_assets/sounds/carl_dialogues/target_acquired_1.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/target_acquired_2.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/target_acquired_3.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/target_acquired_4.wav"),],
	"dodging" : [],
	"hurt" : [],
	"approaching" : [preload("res://assets/my_assets/sounds/carl_dialogues/approaching_1.wav"), 
		preload("res://assets/my_assets/sounds/carl_dialogues/approaching_2.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/approaching_3.wav")],
	"searching" : [preload("res://assets/my_assets/sounds/carl_dialogues/searching_1.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/searching_2.wav"),
		preload("res://assets/my_assets/sounds/carl_dialogues/searching_3.wav")],
	}
