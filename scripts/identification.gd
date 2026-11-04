extends Control

const MAIN_SCENE_PATH : String = "res://scenes/main.tscn"

var changing_scene : bool = false


func _input(event : InputEvent) -> void:
	if changing_scene or not _is_activation_event(event):
		return

	changing_scene = true
	get_tree().call_deferred("change_scene_to_file", MAIN_SCENE_PATH)


func _is_activation_event(event : InputEvent) -> bool:
	if event is InputEventMouseButton:
		return event.pressed
	if event is InputEventScreenTouch:
		return event.pressed
	if event is InputEventKey:
		return event.pressed and not event.echo
	return false
