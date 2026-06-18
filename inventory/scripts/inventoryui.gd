extends Control


@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var inventory = preload("res://inventory/inventory.tres")


func _ready() -> void:
	InventoryGlobal.update.connect(update_inv)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		PlayerGlobal.in_menu = !PlayerGlobal.in_menu
		if !visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func update_inv():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i]) #update each slot with the same number in the inventory array
