extends Node

class_name Door

export(NodePath) onready var open_area = get_node(open_area) as Area
export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree
export(NodePath) onready var locker_led = get_node(locker_led) as MeshInstance

export(Array, Color) onready var color_list

export(bool) onready var is_locked setget set_is_locked, get_is_locked
export(bool) onready var keep_opened setget set_keep_opened, get_keep_opened
export(bool) onready var open_when_unlocked setget set_open_when_unlocked, get_open_when_unlocked
export(float) var lock_door_time:= 1.0

#Flag per segnalare se la porta è aperta o chiusa
var is_open: bool setget set_is_open, get_is_open

#Allo scadere del timer la porta si blocca. 
var lock_door_timer: Timer


func _ready():
	if GameEvents.connect("lock_door", self, "_on_door_locked") != OK:
		print("failure")
	if GameEvents.connect("open_door", self, "_on_door_opened") != OK:
		print("failure")
	
	#Autostart = false, OneShot = true.
	lock_door_timer = Util.setup_timer(lock_door_timer, self, lock_door_time, false, true)
	
	call_deferred("setup_timers")
	
	is_open = not is_locked and open_when_unlocked
	GameEvents.emit_lock_door(self, is_locked)


func _physics_process(_delta):
	door_behaviour()
	
	animation_tree.set("parameters/conditions/is_closed", not is_open)
	animation_tree.set("parameters/conditions/is_opened", is_open)

# Comportamento della porta di default
func door_behaviour():
	# Se non è bloccata, controlla la presenza di personaggi nell'area di apertura
	if not is_locked:
		var colliders = open_area.get_overlapping_bodies()
		
		#Se è presente qualcuno e la porta è chiusa, allora apri la porta
		if colliders.size() > 0:
			if not is_open:
				GameEvents.emit_signal("open_door", self, true)
		else:
			#Se nessun persongaggio è nell'area e la porta può chiudersi, chiudila
			if is_open and not keep_opened:
				GameEvents.emit_signal("open_door", self, false)


# Callback invocata quando si blocca o sblocca una porta.
func _on_door_locked(door, _is_locked: bool):
	if door == self :
		is_locked = _is_locked
		
		#Se la porta è stata sbloccata, se previsto, aprila
		if not is_locked:
			if open_when_unlocked:
				GameEvents.emit_signal("open_door", self, true)
		else:
			GameEvents.emit_signal("open_door", self, false)
		
		change_led_color()

#Callback invocata allo scadere del timer di chiusura. Il timer può essere invocato in varie condizioni. 
#Nel comportamento di default, il timer non viene mai richiamato.
func on_close_door_timer_timeout():
	GameEvents.emit_signal("lock_door", self, true)


func change_led_color():
	var led_material: Material = locker_led.get("material/0")
	var new_color: Color
	
	if is_locked:
		new_color = color_list[Enums.DoorState.LOCKED]
	else:
		new_color = color_list[Enums.DoorState.UNLOCKED]

	led_material.emission = new_color


func setup_timers():
	if lock_door_timer.connect("timeout", self, "on_close_door_timer_timeout") != OK:
		print("failure")


func _on_door_opened(door, _is_open: bool):
	if door == self:
		is_open = (_is_open or keep_opened) and not is_locked


func set_is_open(_is_open: bool) -> void:
	is_open = _is_open


func get_is_open() -> bool:
	return is_open


func set_is_locked(_is_locked: bool) -> void:
	is_locked = _is_locked


func get_is_locked() -> bool:
	return is_locked


func set_keep_opened(_keep_opened: bool) -> void:
	keep_opened = _keep_opened


func get_keep_opened() -> bool:
	return keep_opened


func set_open_when_unlocked(_open_when_unlocked: bool) -> void:
	open_when_unlocked = _open_when_unlocked


func get_open_when_unlocked() -> bool:
	return open_when_unlocked
