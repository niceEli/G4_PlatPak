extends CharacterBody3D

@onready var camera_3d = $Eyes

@export_category("Mouse / Camera Options")
@export_range(1,200) var default_sensitivity = 25

@export_category("Movement Options")
@export var accelerate_speed = 5.0
@export var air_accelerate_speed = 2.0
@export var max_ground_speed = 20.0
@export var max_air_speed = 15.0
@export var jump_velocity = 4.5
@export var friction = 0.8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x) * default_sensitivity / 100)
		camera_3d.rotate_x(-deg_to_rad(event.relative.y) * default_sensitivity / 100)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_pressed("action_jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * accelerate_speed
		velocity.z = direction.z * accelerate_speed
	else:
		velocity.x = move_toward(velocity.x, 0, accelerate_speed)
		velocity.z = move_toward(velocity.z, 0, accelerate_speed)

	move_and_slide()
