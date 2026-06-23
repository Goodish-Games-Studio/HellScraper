extends CharacterBody3D

@onready var neck: Node3D = $neck
@onready var head: Node3D = $neck/camyaw
@onready var spring: SpringArm3D = $neck/camyaw/campitch/SpringArm3D
@onready var stand_col: CollisionShape3D = $stand_col
@onready var crouch_col: CollisionShape3D = $crouch_col
@onready var crouchcast: RayCast3D = $crouchcast
@onready var camera: Camera3D = $neck/camyaw/campitch/SpringArm3D/Camera3D
@onready var attackcast: RayCast3D = $Attackcast

@onready var mouse_sens = 0.3

@export var walk_speed = 5.0
@export var sprint_speed = 7.0
@export var crouch_speed = 3.0

var current_speed = 5.0

var jump_velocity = 8

const GRAV = 22

var crouching_depth = -0.6


#func _ready() -> void:
#	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if PlayerGlobal.in_menu:
		return
	if event is InputEventMouseMotion:
		
		neck.rotate_y(-deg_to_rad(event.relative.x * mouse_sens))
		head.rotate_x(-deg_to_rad(event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta: float) -> void:
	if !PlayerGlobal.in_menu:
		jump(delta)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if Input.is_action_just_pressed("esc"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	grav(delta)
	states(delta)
	move(delta)
	
	attack()
	
	move_and_slide()


func states(delta):
	if Input.is_action_pressed("crouch"):
		
		current_speed = crouch_speed
		neck.position.y = lerp(neck.position.y, crouching_depth, delta*20)
		
		crouch_col.disabled = false
		stand_col.disabled = true
	
	elif !crouchcast.is_colliding():
	
	# Standing
		crouch_col.disabled = true
		stand_col.disabled = false
		
		neck.position.y = lerp(neck.position.y, 0.0, delta*20)
		
		if Input.is_action_pressed("sprint"):
			# Sprinting
			current_speed = sprint_speed
		else:
			# Walking
			current_speed = walk_speed
	
	else:
		current_speed = walk_speed


func move(delta):
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !PlayerGlobal.in_menu:
		velocity.x = direction.x * 5.0
		velocity.z = direction.z * 5.0
	else:
		velocity.x = move_toward(velocity.x, 0, 5.0)
		velocity.z = move_toward(velocity.z, 0, 5.0)
	
	if input_dir.length() > 0.0 or spring.spring_length <  0.6:
		rotation.y = lerp_angle(rotation.y, neck.global_rotation.y, 10.0 * delta)
		neck.rotation.y = lerp(neck.rotation.y, 0.0, 10.0 * delta)

func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

func grav(delta):
	if not is_on_floor():
		velocity.y -= GRAV * delta


func attack():
	if Input.is_action_just_pressed("attack") and attackcast.get_collider():
		print("try")
		if attackcast.get_collider().is_in_group("attackable"):
			attackcast.get_collider().get_parent().hit(20)


func collect(item):
	print(str(item))
	InventoryGlobal.insert_hot(item)
