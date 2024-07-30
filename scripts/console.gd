extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tex: String = ""
	var n: int = 0
	for i in GameManager.consolelog:
		if i.time > Time.get_ticks_msec() - 5000 and i:
			tex += "[{id}] ({risk}) {time}: {val}\n".format({"id": n, "time": i.time, "val": i.value, "risk": i.risk})
		n+=1
	text = tex
