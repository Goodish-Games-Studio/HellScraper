extends Node3D



func hit(damage):
	var stick = load("res://Scenes/Items/stick.tscn")
	var stick_instance = stick.instance()
	stick_instance.set_name("stick")
	get_tree().root.add_child(stick_instance)
