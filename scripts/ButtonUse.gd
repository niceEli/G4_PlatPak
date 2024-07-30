extends Node3D
@onready var button_use = $ButtonUse
@onready var button_collisions = $ButtonUse/ButtonCollisions

@export var signalName: String = ""
@export var inverse: bool = false

func _ready():
	if signalName == "":
		GameManager.print("signalName is empty", GameManager.risk_type.error)
		return
	GameManager.signals[signalName] = false

func _physics_process(_delta):
	var amount_of_bodies = len(button_use.get_overlapping_bodies())
	var is_colliding = bool(amount_of_bodies)
	if signalName == "":
		GameManager.print("signalName is empty", GameManager.risk_type.error)
		return
	if inverse:
		GameManager.signals[signalName] = !is_colliding
		return
	GameManager.signals[signalName] = is_colliding
