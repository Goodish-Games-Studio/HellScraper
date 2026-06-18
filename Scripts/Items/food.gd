extends Node3D

@export var item: InvItem
@onready var collision: Area3D = $collision


func _process(delta: float) -> void:
	var bodies = collision.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			body.collect(item)
			queue_free()
