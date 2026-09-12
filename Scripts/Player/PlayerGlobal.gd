extends Node

@onready var health = 60
@onready var hunger = 100

@onready var in_menu = false


func _process(delta: float) -> void:
	if in_menu:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
