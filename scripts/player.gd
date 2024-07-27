extends CharacterBody3D

@onready var camera_3d = $Eyes
@onready var hold_point = $Eyes/HoldPoint
@onready var hold_check = $Eyes/HoldCheck


@export var sens = 0.25

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var held_obj : RigidBody3D;

var vel

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x) * sens)
		camera_3d.rotate_x(-deg_to_rad(event.relative.y) * sens)
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_just_pressed("action_pickup"):
		if hold_check.get_collider() and hold_check.get_collider() is RigidBody3D and hold_check.get_collider().mass <= 50:
			held_obj = hold_check.get_collider()

	if held_obj:
		held_obj.linear_velocity = (hold_point.global_position - held_obj.global_position) * 10
		
		var hp: Vector3 = hold_point.global_rotation
		var ho: Vector3 = held_obj.global_rotation
		
		var hpq: Quaternion = Quaternion.from_euler(hp)
		var hoq: Quaternion = Quaternion.from_euler(ho)
		
		var hpqi: Quaternion = hpq.inverse()
		var hoqi: Quaternion = hoq.inverse()
		
		vel = (hpq * hoqi)
		var velv = Vector3(vel.x, vel.y, vel.z)
		
		held_obj.angular_velocity = velv * 10
		
	if Input.is_action_just_released("action_pickup"):
		if held_obj:
			held_obj.sleeping = false
			held_obj = null

	move_and_slide()
