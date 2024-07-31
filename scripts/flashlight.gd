extends SpotLight3D

signal activate
signal deactivate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("action_flashlight"):
		visible = !visible
		if visible:
			activate.emit()
		else:
			deactivate.emit()
