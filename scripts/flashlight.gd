extends SpotLight3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("action_flashlight"):
		visible = !visible
