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

	var do_collide: bool = GameManager._get_signal(signalName, saved_signals, inverse)

	door_collision.visible = do_collide
	door_collision.use_collision = do_collide 
