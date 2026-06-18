extends Panel


@onready var icon: Sprite2D = $icon
@onready var count: Label = $count


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update(slot: InvSlot):
	if !slot or !slot.item: # if the item in the array is empty
		icon.visible = false
		count.visible = false
	else: # if there is an item in that number of the inv array
		icon.texture = slot.item.icon
		icon.visible = true
		if slot.count > 1:
			count.visible = true
		count.text = str(slot.count)
