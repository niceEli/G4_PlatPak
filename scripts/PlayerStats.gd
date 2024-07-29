extends Label

var player: CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_parent().get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	set_text("FPS:      {fps}\nX:            {x}\nY:            {y}\nZ:            {z}\nSPEED: {speed} M/S".format({"x": str(round(player.global_position.x * 100) / 100), "y": str(round(player.global_position.y * 100) / 100), "z": str(round(player.global_position.z * 100) / 100), "fps": str(Engine.get_frames_per_second()), "speed": str(round(player.get_real_velocity().length()*100)/100)}))
