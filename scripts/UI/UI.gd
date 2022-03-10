extends Control

class_name UI

export(NodePath) onready var _warning_label = get_node(_warning_label) as Label

export(NodePath) onready var _warning_animation_player = get_node(_warning_animation_player) as AnimationPlayer
export(NodePath) onready var _weapon_grid_container = get_node(_weapon_grid_container) as GridContainer

export(NodePath) onready var _current_weapon_container = get_node(_current_weapon_container) as Control
export(NodePath) onready var _current_life_container = get_node(_current_life_container) as Control

#debug
export(Resource) onready var runtime_data = runtime_data as RuntimeData

onready var weapon_item_UI = preload("res://nodes/UI/weapon_item_UI.tscn")
onready var life_item_UI = preload("res://nodes/UI/life_item_UI.tscn")

export var _max_weapon_item_UI: int = 3

func _ready():
	GameEvents.connect("reload", self, "_on_reloading")
	GameEvents.connect("warning", self, "_on_warning")
	
	GameEvents.connect("inventory_changed", self, "_on_inventory_changed")
	GameEvents.connect("current_weapon_changed", self, "_on_current_weapon_changed")
	
	_warning_label.visible = false

func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	_update_weapon_container_UI(_inventory, _item_changed)
	_update_life_container_UI(_inventory, _item_changed)


func _process(delta):
	print(runtime_data.current_gameplay_state)
	get_node("MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Debug").text = String(runtime_data.current_gameplay_state)


func _on_current_weapon_changed(_weapon: Weapon, character: Character):
	if character is Player:
		var _weapon_item_UI_list: Array = _weapon_grid_container.get_children()
		var _last_weapon_item_UI: WeaponItemUI
		
		#Faccio scorrere i pannelli in modo che il primo della lista sia quello che contiene l'arma corrente
		for _weapon_item_UI in _weapon_item_UI_list:
			_last_weapon_item_UI = _weapon_grid_container.get_child(_weapon_item_UI_list.size() - 1)
			_weapon_grid_container.remove_child(_weapon_item_UI)
			_weapon_grid_container.add_child_below_node(_last_weapon_item_UI, _weapon_item_UI)

			if _weapon_grid_container.get_child(0).name_label.text == _weapon.name:
				break
		
		#Per questioni di spazio visualizzo solo i primi _max_weapon_item_UI pannelli
		var _count: int = 0
		for _weapon_item_UI in _weapon_grid_container.get_children():
			if _count < _max_weapon_item_UI:
				_weapon_item_UI.visible = true
				_count += 1
				continue
			
			_weapon_item_UI.visible = false


func _on_warning(_text: String) -> void:
	if _warning_label.visible == false:
		_warning_label.visible = true
	
	_warning_label.text = _text
	if not _warning_animation_player.is_playing():
		_warning_animation_player.play("warning")


func _on_reloading(character: Character):
	if character is Player:
		if _warning_label.visible == false:
			_warning_label.visible = true
		
		_warning_label.text = "Reloading..."
		if not _warning_animation_player.is_playing():
			_warning_animation_player.play("warning")


func _update_weapon_container_UI(_inventory: Inventory, _item_changed: Dictionary):
	var _item: Item = _item_changed.item_reference
	
	if _item is Weapon and _item_changed.status != Enums.ItemStatus.LOCKED:
		var _weapon_item_UI_list: Array = _weapon_grid_container.get_children()
		var _weapon_list: Array = _inventory.get_item_list(Enums.ItemTipology.WEAPON)
	
		var found: bool = false
		#Controllo che il pannello che mostra l'arma non sia già stato aggiunto
		for _weapon_item_UI in _weapon_item_UI_list:
			_weapon_item_UI = _weapon_item_UI as WeaponItemUI
			if _weapon_item_UI.name_label.text != _item.name:
				continue
			
			found = true
		
		if not found:
			#Nel caso in cui non sia presente devo inserirlo come nodo figlio di _weapon_grid_container
			
			#Ricavo prima un array che contiene tutte gli oggetti di tipo Weapon presenti nell'inventario
			var _weapon_item_list: Array
			for _weapon in _weapon_list:
				_weapon_item_list.append(_weapon.item_reference)
			
			#Poi salvo l'indice dell'array in cui è contenuta l'oggetto che devo aggiungere
			var _current_weapon_index: int = _weapon_item_list.find(_item)
			#Ricavo il nome dell'arma precedente a quella che devo aggiungere
			var _previous_name: String = _weapon_item_list[(_current_weapon_index - 1 + _weapon_list.size()) % _weapon_list.size()].name
			
			var _new_weapon_item_UI = weapon_item_UI.instance() as WeaponItemUI
			var _previous_weapon_item_UI: WeaponItemUI
			
			#Cerco il pannello che contiene l'arma che sta una posizione prima nell'elenco delle armi nell'inventario
			for _weapon_item_UI in _weapon_item_UI_list:
				if _weapon_item_UI.name_label.text == _previous_name:
					_previous_weapon_item_UI = _weapon_item_UI
					break
			
			#Se tale pannello è presente, aggiungo al di sotto di esso il pannello appena creato
			#in modo che l'ordine con cui le armi vengono mostrate dalla UI rispecchi quello dell'inventario
			if _previous_weapon_item_UI:
				_weapon_grid_container.add_child_below_node(_previous_weapon_item_UI, _new_weapon_item_UI)
			else:
				_weapon_grid_container.add_child(_new_weapon_item_UI)

			_new_weapon_item_UI.setup(_item, _inventory)


func _update_life_container_UI(_inventory: Inventory, _item_changed: Dictionary):
	var _item: Item = _item_changed.item_reference
	
	if _item is LifeSlot:
		var _life_item_UI = life_item_UI.instance() as LifeItemUI
		_current_life_container.add_child(_life_item_UI)
		
		_life_item_UI.setup(_item, _inventory)
