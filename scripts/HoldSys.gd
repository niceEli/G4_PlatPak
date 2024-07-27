extends Node3D

@onready var hold_point = $HoldPoint
@onready var hold_check = $HoldCheck
var player

func _ready():
	player = get_parent().get_parent()

var held_obj: RigidBody3D;

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

func _physics_process(delta):
	if Input.is_action_just_pressed("action_pickup"):
		if hold_check.get_collider() and hold_check.get_collider() is RigidBody3D and hold_check.get_collider().mass <= 50:
			held_obj = hold_check.get_collider()

	if held_obj:
		held_obj.linear_velocity = ((hold_point.global_position - held_obj.global_position) * 10) + player.velocity
		
		held_obj.angular_velocity = calc_angular_velocity(held_obj.global_basis, hold_point.global_basis) * 10
		
	if Input.is_action_just_released("action_pickup"):
		if held_obj:
			held_obj.sleeping = false
			held_obj = null
