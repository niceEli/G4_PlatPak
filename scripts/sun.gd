extends DirectionalLight3D


func _process(delta):
	update_sun_position(delta)

func update_sun_position(_delta):
	var datetime = Time.get_datetime_dict_from_system()
	var hours = datetime["hour"]
	var minutes = datetime["minute"]
	var seconds = datetime["second"]
	
	var seconds_of_day: float = hours * 3600 + minutes * 60 + seconds
	
	# Example: Adjust the rotation of the sun based on the seconds of the day
	var max_rotation = 2 * PI  # Full rotation in radians (360 degrees)
	var rotation_angle = max_rotation * (seconds_of_day / 86400.0)  # Normalize to [0, 1] range
	
	rotation = Vector3(rotation_angle, 1, 0)
