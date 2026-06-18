extends Resource

class_name Inv

@export var slots: Array[InvSlot]
@export var type: String


func insert(item: InvItem):
	# Checks if we already have this item in our inventory
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		# Adds to existing item
		item_slots[0].count += 1
	# Checks if we don't already have this item in our inventory
	else:
		if type == "hotbar" and InventoryGlobal.full_hotbar:
			InventoryGlobal.insert_inv(item)
			return
		
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			# Adds item to empty slot
			emptyslots[0].item = item
			emptyslots[0].count = 1
	InventoryGlobal.update.emit()

func check_slot(slot, item):
	return slot.item == item
