extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var tex: String = ""
	var n: int = 0
	for i in GameManager.consolelog:
		if i.time > Time.get_ticks_msec() - 5000 and i and n <= 100:
			tex += "[{id}] ({risk}) {time}: {val}\n".format({"id": n, "time": i.time, "val": i.value, "risk": i.risk})
		n+=1
	text = tex
