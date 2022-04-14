extends Usable

class_name LifeSlot

export(Texture) var under_progress_bar_texture
export(Texture) var progress_bar_texture

func use(_character):
	#L'ultimo parametro esplicita il fatto che si vuole maxare la vita. Lo zero è superfluo
	GameEvents.emit_signal("change_current_life", 0, true, _character)
