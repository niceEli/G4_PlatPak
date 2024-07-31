extends CharacterBody3D

@onready var camera_3d = $Eyes

@export_category("Mouse / Camera Options")
@export_range(1,200) var default_sensitivity : float = 15

@export_category("Movement Variables")
## Speed of walking as a fraction of running
@export_range(0.00, 1.00) var walk_speed : float = 0.1
## Acceleration when grounded
@export var ground_accelerate : float = 250
## Acceleration when in the air
@export var air_accelerate : float = 85
## Max velocity on the ground
@export var max_ground_velocity : float = 10
## Max velocity in the air
@export var max_air_velocity : float = 1.5
## Jump force multiplier
@export var jump_force : float = 0.6
## Easy BHopping Mode
@export var jump_when_held : bool = true
## Friction
@export var friction : float = 6
## Bunnyhop window frame length
@export var bhop_frames : int = 2
## Whether bunnyhopping should be 'additive' - whether it should 
## converge to the player's wishdir
@export var additive_bhop : bool = true

signal too_fast(speed: float)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 3

## Get player's intended direction.

func get_wishdir():
	if Input.is_action_pressed("action_run"):
		return Vector3.ZERO + \
			(transform.basis.z * Input.get_axis("move_forward", "move_back")) +\
			(transform.basis.x * Input.get_axis("move_left", "move_right"))
	else:
		return Vector3.ZERO + \
			(transform.basis.z * Input.get_axis("move_forward", "move_back") * walk_speed) +\
			(transform.basis.x * Input.get_axis("move_left", "move_right") * walk_speed)
			
## Get jump force
func get_jump():
	return sqrt(4 * jump_force * gravity)

## Get gravity force
func get_gravity(delta):
	return gravity * delta

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x) * default_sensitivity / 100)
		camera_3d.rotation.x = clampf(camera_3d.rotation.x + (-deg_to_rad(event.relative.y) * default_sensitivity / 100), deg_to_rad(-90), deg_to_rad(90))

func update_controller_camera():
	var cam_axis_x = Input.get_axis("turn_left", "turn_right")
	var cam_axis_y = Input.get_axis("turn_down", "turn_up")
	rotate_y(-deg_to_rad(cam_axis_x) * default_sensitivity / 10)
	camera_3d.rotate_x(-deg_to_rad(cam_axis_y) * default_sensitivity / 10)
	camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

######
# All this code was only possible thanks to the technical writeup by Flafla2 available below.
# Most of this was shamelessly adjusted from direct copy-pasting.
#
# Bunnyhopping from the Programmer's Perspective
# https://adrianb.io/2015/02/14/bunnyhop.html
######

## Source-like acceleration function
func accelerate(accelDir, prevVelocity, acceleration, max_vel, delta):
	# Calculate projected velocity for the next frame
	var projectedVel = prevVelocity.dot(accelDir)
	# Calculate the accelerated velocity given the maximum velocity, projected velocity, and current acceleration
	var accelVel = clamp(max_vel - projectedVel, 0, acceleration * delta)
	# Return the previous velocity in addition to the new velocity post acceleration
	return prevVelocity + accelDir * accelVel

## Get intended velocity for the next frame
func get_next_velocity(previousVelocity, delta):
	var grounded = is_on_floor()
	var can_jump = grounded # Jumping is a seperate var in case of additive bunnyhopping modifying grounded
	
	# Apply friction if player is grounded, and if the frame_timer indicates it should be applied
	if grounded and (frame_timer >= bhop_frames):
		var speed = previousVelocity.length()
		if speed != 0:
			var drop = speed * friction * delta
			previousVelocity *= max(speed - drop, 0) / speed
	else:
		# If bunnyhopping is additive, we should use the air velocity and accelerate values for all frames
		# that the bunnyhop is possible
		if not additive_bhop:
			grounded = false
	
	var max_vel = max_ground_velocity if grounded else max_air_velocity
	var accel = ground_accelerate if grounded else air_accelerate
	
	# Calculate velocity for next frame
	var vel = accelerate(get_wishdir(), previousVelocity, accel, max_vel, delta)
	# Apply gravity
	vel += Vector3.DOWN * get_gravity(delta)
	
	# Apply jump if desired
	if (Input.is_action_pressed("action_jump") if jump_when_held else Input.is_action_just_pressed("action_jump")) \
			and can_jump:
		vel.y = get_jump()
	
	# Return the new velocity
	return vel

## Count of frames since last grounded
var frame_timer = bhop_frames
## Update frame timer if necessary
func update_frame_timer():
	if is_on_floor():
		frame_timer += 1
	else:
		frame_timer = 0

## Get frame velocity and update character body
func handle_movement(delta):
	update_controller_camera()
	# Update the bhop frame timer
	update_frame_timer() 
	velocity = get_next_velocity(velocity, delta)
	if velocity.length() >= 1000:
		too_fast.emit(velocity.length())
		GameManager.print("you are going very fast, speed: " + str(roundf(velocity.length() * 10) / 10), GameManager.risk_type.warn)
	move_and_slide()

func _physics_process(delta):
	handle_movement(delta)
