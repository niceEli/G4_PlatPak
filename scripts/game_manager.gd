extends Node
class_name game_manager

### Init Start

func _ready():
	get_tree().connect("tree_changed", reset_common_data)

func reset_common_data():
	signals.clear()

### Init end

### Console Start

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

func print(val: String, risk: risk_type = risk_type.info):
	var time = Time.get_ticks_msec()
	var logval = log_message.new()
	logval.time = Time.get_ticks_msec()
	logval.value = val
	if risk >= 0 and risk < risk_type.size():
		logval.risk = risk_type.find_key(risk)
	else:
		logval.risk = "unkownRISCType"
	if consolelog.size() > 100:
		consolelog.pop_back()
	consolelog.push_front(logval)
	print("({risk}) {time}: {val}".format({"time": logval.time, "val": logval.value, "risk": logval.risk}))

### Console End

### Signals Start

@export var signals: Dictionary = {}
@export var saved_signals: Dictionary = {}

func _set_signal(key: String, value: bool, saved: bool = false, inverse: bool = false) -> void:
	var val: bool = value

	if inverse:
		val = !val

	if !saved:
		signals[key] = val
	else:
		saved_signals[key] = val

func _get_signal(key: String, saved: bool = false, inverse: bool = false) -> bool:
	var val: bool

	if saved:
		if saved_signals.has(key):
			val = saved_signals[key]
		else:
			val = false
	else:
		if signals.has(key):
			val = signals[key]
		else:
			val = false
	
	if inverse:
		val = !val
	
	return val

func _signal_exists(key: String, saved: bool = false) -> bool:
	if saved:
		return saved_signals.has(key)
	else:
		return signals.has(key)

func _remove_signal(key: String, saved: bool = false) -> void:
	if saved:
		if saved_signals.has(key):
			saved_signals.erase(key)
	else:
		if signals.has(key):
			signals.erase(key)

### Signals End
