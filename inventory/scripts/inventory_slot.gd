extends Panel


@onready var icon: Sprite2D = $icon
@onready var count: Label = $count
@onready var highlight: Sprite2D = $highlight

enum Type {Inventory, Hotbar}
@export var type: Type
@export var selector_path: Node2D
@export var slot_num: int

var selected = false
var expansion = 1.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#moving items
	if selected:
		if slot_num != InventoryGlobal.hot_selected:
			highlight.visible = true
		scale.x = lerp(scale.x, expansion, 0.5)
		scale.y = lerp(scale.y, expansion, 0.5)
		if type == Type.Hotbar and selector_path:
			if slot_num == InventoryGlobal.hot_selected:
				selector_path.scale.x = lerp(scale.x, expansion, 0.5)
				selector_path.scale.y = lerp(scale.y, expansion, 0.5)
	else:
		highlight.visible = false
		scale.x = lerp(scale.x, 1.0, 0.5)
		scale.y = lerp(scale.y, 1.0, 0.5)
		if type == Type.Hotbar and selector_path:
			if slot_num == InventoryGlobal.hot_selected:
				selector_path.scale.x = lerp(scale.x, 1.0, 0.5)
				selector_path.scale.y = lerp(scale.y, 1.0, 0.5)
	
	if InventoryGlobal.inv_swap_selected != slot_num:
		selected = false


func update(slot: InvSlot):
	if !slot or !slot.item: # if the item in the array is empty
		icon.visible = false
		count.visible = false
	else: # if there is an item in that number of the inv array
		icon.texture = slot.item.icon
		icon.visible = true
		if slot.count > 1:
			count.visible = true
		else:
			count.visible = false
		count.text = str(slot.count)


func _on_button_button_down() -> void:
	if !InventoryGlobal.selected:
		selected = true
		InventoryGlobal.selected = true
		InventoryGlobal.inv_swap_selected = slot_num
	else:
		match type:
			Type.Inventory:
				to_inv()
			Type.Hotbar:
				to_hot()


func to_inv():
	if InventoryGlobal.inv_swap_selected <= 8: # coming from hotbar
		var local_hotbar = InventoryGlobal.hotbar
		var local_inventory = InventoryGlobal.inventory
		
		var temp = local_inventory.slots[slot_num-9]
		local_inventory.slots[slot_num-9] = local_hotbar.slots[InventoryGlobal.inv_swap_selected]
		local_hotbar.slots[InventoryGlobal.inv_swap_selected] = temp
		
		InventoryGlobal.hotbar.slots = local_hotbar.slots
		InventoryGlobal.inventory.slots = local_inventory.slots
		InventoryGlobal.update.emit()
	else: # coming from inventory
		var local_inventory = InventoryGlobal.inventory
		
		var temp = local_inventory.slots[slot_num-9]
		local_inventory.slots[slot_num-9] = local_inventory.slots[InventoryGlobal.inv_swap_selected-9]
		local_inventory.slots[InventoryGlobal.inv_swap_selected-9] = temp
		
		InventoryGlobal.inventory.slots = local_inventory.slots
		InventoryGlobal.update.emit()
	
	InventoryGlobal.inv_swap_selected = -1
	InventoryGlobal.selected = false

func to_hot():
	if InventoryGlobal.inv_swap_selected >= 9: # coming from inventory
		var local_hotbar = InventoryGlobal.hotbar
		var local_inventory = InventoryGlobal.inventory
		
		var temp = local_hotbar.slots[slot_num]
		local_hotbar.slots[slot_num] = local_inventory.slots[InventoryGlobal.inv_swap_selected-9]
		local_inventory.slots[InventoryGlobal.inv_swap_selected-9] = temp
		
		InventoryGlobal.hotbar.slots = local_hotbar.slots
		InventoryGlobal.inventory.slots = local_inventory.slots
		InventoryGlobal.update.emit()
	else: # coming from hotbar
		var local_hotbar = InventoryGlobal.hotbar
		
		var temp = local_hotbar.slots[slot_num-9]
		local_hotbar.slots[slot_num] = local_hotbar.slots[InventoryGlobal.inv_swap_selected-9]
		local_hotbar.slots[InventoryGlobal.inv_swap_selected-9] = temp
		
		InventoryGlobal.hotbar.slots = local_hotbar.slots
		InventoryGlobal.update.emit()
	
	InventoryGlobal.inv_swap_selected = -1
	InventoryGlobal.selected = false

	
