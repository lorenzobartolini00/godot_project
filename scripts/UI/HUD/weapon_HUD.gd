extends GridContainer

class_name WeaponHUD


export(NodePath) onready var hud = get_node(hud) as HUD
export var _max_weapon_item_UI: int = 3


func _ready():
	if GameEvents.connect("inventory_changed", self, "_on_inventory_changed") != OK:
		print("failure")
	if GameEvents.connect("current_weapon_changed", self, "_on_current_weapon_changed") != OK:
		print("failure")


func _on_inventory_changed(_inventory: Inventory, _item_changed: Dictionary):
	_update_weapon_container_UI(_inventory, _item_changed)


func _on_current_weapon_changed(_weapon: Weapon, character: Character):
	if character == hud.get_character():
		var _weapon_item_UI_list: Array = self.get_children()
		var _last_weapon_item_UI: WeaponItemUI
		
		#Faccio scorrere i pannelli in modo che il primo della lista sia quello che contiene l'arma corrente
		for _weapon_item_UI in _weapon_item_UI_list:
			_last_weapon_item_UI = self.get_child(_weapon_item_UI_list.size() - 1)
			self.remove_child(_weapon_item_UI)
			self.add_child_below_node(_last_weapon_item_UI, _weapon_item_UI)

			if self.get_child(0).weapon_name == _weapon.name:
				break
		
		update_panel_visibility()


func update_panel_visibility():
	#Per questioni di spazio visualizzo solo i primi _max_weapon_item_UI pannelli
	var _count: int = 0
	for _weapon_item_UI in self.get_children():
		if _count < _max_weapon_item_UI:
			_weapon_item_UI.visible = true
			_count += 1
			continue
			
		_weapon_item_UI.visible = false



func _update_weapon_container_UI(_inventory: Inventory, _item_changed: Dictionary):
	var _item: Item = _item_changed.item_reference
	
	if _item is Weapon and _item_changed.status != Enums.ItemStatus.LOCKED:
		var _weapon_item_UI_list: Array = self.get_children()
		var _weapon_list: Array = _inventory.get_dictionary_item_list(Enums.ItemTipology.WEAPON)
	
		var found: bool = false
		#Controllo che il pannello che mostra l'arma non sia già stato aggiunto
		for _weapon_item_UI in _weapon_item_UI_list:
			_weapon_item_UI = _weapon_item_UI as WeaponItemUI
			if _weapon_item_UI.weapon_name != _item.name:
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
			
			var _new_weapon_item_UI = load(_item.weapon_item_UI_path).instance() as WeaponItemUI
			var _previous_weapon_item_UI: WeaponItemUI
			
			#Cerco il pannello che contiene l'arma che sta una posizione prima nell'elenco delle armi nell'inventario
			for _weapon_item_UI in _weapon_item_UI_list:
				if _weapon_item_UI.weapon_name == _previous_name:
					_previous_weapon_item_UI = _weapon_item_UI
					break
			
			#Se tale pannello è presente, aggiungo al di sotto di esso il pannello appena creato
			#in modo che l'ordine con cui le armi vengono mostrate dalla UI rispecchi quello dell'inventario
			if _previous_weapon_item_UI:
				self.add_child_below_node(_previous_weapon_item_UI, _new_weapon_item_UI)
			else:
				self.add_child(_new_weapon_item_UI)

			_new_weapon_item_UI.setup(_item, _inventory)
		
		update_panel_visibility()
