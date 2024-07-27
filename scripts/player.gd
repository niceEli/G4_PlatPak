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

func calc_angular_velocity(from_basis: Basis, to_basis: Basis) -> Vector3:
	var q1 = from_basis.get_rotation_quaternion()
	var q2 = to_basis.get_rotation_quaternion()

	# Quaternion that transforms q1 into q2
	var qt = q2 * q1.inverse()

	# Angle from quaternion
	var angle = 2 * acos(qt.w)

	# There are two distinct quaternions for any orientation.
	# Ensure we use the representation with the smallest angle.
	if angle > PI:
		qt = -qt
		angle = TAU - angle

	# Prevent divide by zero
	if angle < 0.0001:
		return Vector3.ZERO

	# Axis from quaternion
	var axis = Vector3(qt.x, qt.y, qt.z) / sqrt(1-qt.w*qt.w)

	return axis * angle

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
		
		held_obj.angular_velocity = calc_angular_velocity(held_obj.global_basis, hold_point.global_basis) * 10
		
	if Input.is_action_just_released("action_pickup"):
		if held_obj:
			held_obj.sleeping = false
			held_obj = null

	move_and_slide()
