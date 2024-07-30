extends Node
class_name game_manager

class log_message:
	var time: float
	var value: String
	var risk: String

enum risk_type{
	info,
	warn,
	error,
	severe,
	catastrophic
}

@onready var consolelog: Array[log_message]

func print(val: String, risk: risk_type = 0):
	var time = Time.get_ticks_msec()
	print(val)
	var logval = log_message.new()
	logval.time = Time.get_ticks_msec()
	logval.value = val
	if risk >= 0 and risk < risk_type.size():
		logval.risk = risk_type.find_key(risk)
	else:
		logval.risk = "unkownRISCType"
	consolelog.push_front(logval)
	
