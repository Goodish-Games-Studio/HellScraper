extends Control


@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var hotbar = preload("res://inventory/hotbar.tres")
@onready var selector: Panel = $NinePatchRect/selector
@onready var inventory = preload("res://inventory/inventory.tres")


var slot_selected = 0
var item_selected

func _ready() -> void:
	InventoryGlobal.update.connect(update_inv)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var number_pressed = event.keycode - KEY_1
			slot_selected = number_pressed



func _process(delta: float) -> void:
	if hotbar_full():
		InventoryGlobal.full_hotbar = true
	else:
		InventoryGlobal.full_hotbar = false
	
	#region slot selecting
	
	selector.position.x = (36 * slot_selected) + 11
	
	if inventory.slots[slot_selected].item != null:
		item_selected = inventory.slots[slot_selected].item.name
	
	if Input.is_action_just_pressed("scroll_down"):
		if slot_selected != 8:
			slot_selected += 1
		elif slot_selected == 8:
			slot_selected = 0
	
	if Input.is_action_just_released("scroll_up"):
		if slot_selected != 0:
			slot_selected -= 1
		elif slot_selected == 0:
			slot_selected = 8
	
	if inventory.slots[slot_selected] == InvSlot:
		if inventory.slots[slot_selected].amount < 1:
			inventory.slots[slot_selected] = null
	
	#endregion


func update_inv():
	for i in range(min(hotbar.slots.size(), slots.size())):
		slots[i].update(hotbar.slots[i]) #update each slot with the same number in the inventory array


func hotbar_full() -> bool:
	var full = true
	for slot in hotbar.slots:
		if slot.count == 0:
			full = false
	return full
