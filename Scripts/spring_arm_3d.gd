extends SpringArm3D

var delta

@onready var hands: Node3D = $"../../Hand"
@onready var camyaw: Node3D = $"../.."
@onready var player: CharacterBody3D = $"../../../.."

func _process(_delta: float) -> void:
	
	delta = _delta
	
	if spring_length <= 0.8:
		spring_length = 0
	
	if spring_length <= 0.5:
		if hands.get_parent().name != camyaw.name:
			hands.reparent(camyaw, true)
			hands.rotation = Vector3.ZERO
	else:
		if hands.get_parent().name != player.name:
			hands.reparent(player, true)
			hands.rotation = Vector3.ZERO
	
	if Input.is_action_just_pressed("perspective"):
		if spring_length <= 0.5:
			spring_length = 5
		else:
			spring_length = 0.5
