extends Node

class_name Door

export(NodePath) onready var open_area = get_node(open_area) as Area
export(NodePath) onready var animation_tree = get_node(animation_tree) as AnimationTree

export(bool) onready var is_locked setget set_is_locked, get_is_locked
export(bool) onready var keep_opened setget set_keep_opened, get_keep_opened
export(bool) onready var open_when_unlocked setget set_open_when_unlocked, get_open_when_unlocked

var is_open: bool setget set_is_open, get_is_open


func _ready():
	if GameEvents.connect("unlock_door", self, "_on_door_unlocked") != OK:
		print("failure")
	if GameEvents.connect("open_door", self, "_on_door_opened") != OK:
		print("failure")
	
	is_open = not is_locked and open_when_unlocked


func _physics_process(_delta):
	door_behaviour()
	
	animation_tree.set("parameters/conditions/is_closed", not is_open)
	animation_tree.set("parameters/conditions/is_opened", is_open)


func door_behaviour():
	if not is_locked:
		var colliders = open_area.get_overlapping_bodies()
		
		if colliders.size() > 0:
			if not is_open:
				GameEvents.emit_signal("open_door", self, true)
		else:
			if is_open and not keep_opened:
				GameEvents.emit_signal("open_door", self, false)


func _on_door_unlocked(door, _is_locked: bool = false):
	if door == self :
		is_locked = _is_locked
		
		if not is_locked:
			if open_when_unlocked:
				GameEvents.emit_signal("open_door", self, true)
		else:
			GameEvents.emit_signal("open_door", self, false)


func _on_door_opened(door, _is_open: bool):
	if door == self:
		is_open = _is_open or keep_opened


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
