extends AnimationPlayer

@export var signal_name: String = ""
@export var saved_signals: bool = false
@export var inverse: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var do_play: bool = GameManager._get_signal(signal_name, saved_signals, inverse)

	active = do_play
