extends Resource

class_name Statistics

export(String) var _name
export(Texture) var avatar
export(Dictionary) var sound_list = {
	"hit":[preload("res://assets/my_assets/sounds/carl_dialogues/effects/barrel_hit_1.wav")],
	"explosion":[preload("res://assets/my_assets/sounds/pixabay_sound_effects/explosion_01-6225.mp3"), 
	preload("res://assets/my_assets/sounds/pixabay_sound_effects/musket-explosion-6383.mp3")]
}
#export(bool) var is_alive
