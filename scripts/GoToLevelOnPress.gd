extends Button

@export var new_scene : PackedScene

func _on_pressed():
	get_tree().change_scene_to_packed(new_scene)
