extends Node


func _ready() -> void:
	_hide_cursor()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_MOUSE_ENTER or what == NOTIFICATION_APPLICATION_FOCUS_IN:
		_hide_cursor()


func _hide_cursor() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
