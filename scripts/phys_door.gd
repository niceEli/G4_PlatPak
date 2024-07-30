extends Node3D
@onready var door_collision = $DoorCollision

@export var signalName: String = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if signalName == "":
		GameManager.print("signalName is empty", GameManager.risk_type.error)
		return

	var do_collide: bool = true

	if GameManager.signals.has(signalName):
		do_collide = GameManager.signals[signalName]

	door_collision.visible = do_collide
	door_collision.use_collision = do_collide 
