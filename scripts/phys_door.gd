extends Node3D
@onready var door_collision = $DoorCollision

@export var signalName: String = ""
@export var saved_signals: bool = false
@export var inverse: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if signalName == "":
		GameManager.print("signalName is empty", GameManager.risk_type.error)
		return

	var do_collide: bool = true
	var sig: Dictionary = {}

	if saved_signals:
		sig = GameManager.saved_signals
	else:
		sig = GameManager.signals

	if GameManager.signals.has(signalName):
		do_collide = sig[signalName]
		if inverse:
			do_collide = !do_collide

	door_collision.visible = do_collide
	door_collision.use_collision = do_collide 
