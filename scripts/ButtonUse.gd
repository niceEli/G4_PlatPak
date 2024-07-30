extends Node3D
@onready var button_use = $ButtonUse
@onready var button_collisions = $ButtonUse/ButtonCollisions

@export var signal_name: String = ""
@export var saved_signals: bool = false
@export var inverse: bool = false

func _ready():
	if signal_name == "":
		GameManager.print("signalName is empty", GameManager.risk_type.error)
		return
	if inverse:
		if saved_signals:
			GameManager.saved_signals[signal_name] = true
			return
		GameManager.signals[signal_name] = true
		return
	if saved_signals:
		GameManager.saved_signals[signal_name] = false
		return
	GameManager.signals[signal_name] = false

func _physics_process(_delta):
	var amount_of_bodies = len(button_use.get_overlapping_bodies())
	var is_colliding = bool(amount_of_bodies)
	if signal_name == "":
		GameManager.print("signalName is empty", GameManager.risk_type.error)
		return
	if inverse:
		if saved_signals:
			GameManager.saved_signals[signal_name] = !is_colliding
			return
		GameManager.signals[signal_name] = !is_colliding
		return
	if saved_signals:
		GameManager.saved_signals[signal_name] = is_colliding
		return
	GameManager.signals[signal_name] = is_colliding
