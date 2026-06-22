extends Node3D



func hit(damage):
	var stick = load("res://Scenes/Items/stick.tscn")
	var stick_instance = stick.instantiate()
	stick_instance.set_name("stick")
	get_tree().root.add_child(stick_instance)
	stick_instance.global_position = global_position
	stick_instance.global_position.y +=0.6
	queue_free()
