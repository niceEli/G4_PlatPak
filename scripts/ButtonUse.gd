extends Node3D
@onready var button_use = $ButtonUse
@onready var button_collisions = $ButtonUse/ButtonCollisions

@export var signal_name: String = ""
@export var saved_signals: bool = false
@export var inverse: bool = false

signal collide
signal uncollide

func _physics_process(_delta):
	var amount_of_bodies = len(button_use.get_overlapping_bodies())
	var is_colliding = bool(amount_of_bodies)
	if signal_name == "":
		GameManager.print("signalName is empty", GameManager.risk_type.error)
		return
	GameManager._set_signal(signal_name, is_colliding, saved_signals, inverse)
	if is_colliding:
		collide.emit()
	else:
		uncollide.emit()
