extends GridContainer

class_name LifeHUD


export(NodePath) onready var hud = get_node(hud) as HUD

onready var life_item_UI = preload("res://nodes/UI/life_item_UI.tscn")


func _ready():
	if GameEvents.connect("inventory_changed", self, "_on_inventory_changed") != OK:
		print("failure")
	if GameEvents.connect("current_life_changed", self, "_on_current_life_changed") != OK:
		print("failure")


func _on_inventory_changed(_character, _inventory: Inventory, _item_changed: Dictionary):
	if _character is Player:
		if _character == hud.get_character():
			var _item: Item = _item_changed.item_reference
			var _quantity: int = _item_changed.quantity
			var _status: int = _item_changed.status
			
			var current_number_of_slots: int = self.get_children().size()
			
			if _item is LifeSlot:
				if _status == Enums.ItemStatus.UNLOCKED:
					while current_number_of_slots < _quantity:
						add_new_panel(_item, _character)
						
						current_number_of_slots = self.get_children().size()


func _on_current_life_changed(_life: Life, _character: Character):
	if _character is Enemy:
		if _character == hud.get_character():
			var current_number_of_slots: int = self.get_children().size()
			var life_slot: LifeSlot = _character.get_life_slot()
			
			while current_number_of_slots < life_slot.max_quantity:
				add_new_panel(life_slot, _character)
				
				current_number_of_slots += 1


func add_new_panel(_life: LifeSlot, _character: Character):
	var _life_item_UI = life_item_UI.instance() as LifeItemUI
	self.add_child(_life_item_UI)
	
	_life_item_UI.setup(_life, _character)
