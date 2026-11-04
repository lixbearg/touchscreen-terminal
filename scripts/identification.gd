extends Control

const MAIN_SCENE_PATH : String = "res://scenes/main.tscn"

const WAITING_GESTURES : Array[Texture2D] = [
	preload("res://resources/images/backgrounds/identification_waiting_01.png"),
	preload("res://resources/images/backgrounds/identification_waiting_02.png"),
	preload("res://resources/images/backgrounds/identification_waiting_03.png"),
]

const HOLD_TIME : float = 2.2
const FADE_TIME : float = 0.45
const BLANK_HOLD_TIME : float = 0.15
const GRANTED_FADE_TIME : float = 0.25
const GRANTED_HOLD_TIME : float = 3.0
const SCAN_TIME : float = 1.1

@onready var gesture : TextureRect = $Gesture
@onready var granted : TextureRect = $Granted
@onready var scan_line : Control = $ScanLine
@onready var animation_timer : Timer = $AnimationTimer

var changing_scene : bool = false
var gesture_index : int = 0
var waiting_tween : Tween


func _ready() -> void:
	gesture.texture = WAITING_GESTURES[gesture_index]
	animation_timer.timeout.connect(_on_animation_timer_timeout)
	animation_timer.start(HOLD_TIME)


func _input(event : InputEvent) -> void:
	if changing_scene or not _is_activation_event(event):
		return

	changing_scene = true
	animation_timer.stop()
	if waiting_tween and waiting_tween.is_valid():
		waiting_tween.kill()
	_start_scan()


func _is_activation_event(event : InputEvent) -> bool:
	if event is InputEventMouseButton:
		return event.pressed
	if event is InputEventScreenTouch:
		return event.pressed
	if event is InputEventKey:
		return event.pressed and not event.echo
	return false


func _on_animation_timer_timeout() -> void:
	if changing_scene:
		return

	waiting_tween = create_tween()
	waiting_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	waiting_tween.tween_property(gesture, "modulate:a", 0.0, FADE_TIME)
	waiting_tween.tween_callback(_advance_gesture)
	waiting_tween.tween_interval(BLANK_HOLD_TIME)
	waiting_tween.tween_property(gesture, "modulate:a", 1.0, FADE_TIME)
	waiting_tween.finished.connect(_on_fade_finished)


func _show_granted() -> void:
	granted.visible = true
	granted.modulate.a = 0.0

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(granted, "modulate:a", 1.0, GRANTED_FADE_TIME)
	tween.tween_interval(GRANTED_HOLD_TIME)
	tween.tween_callback(_enter_main)


func _start_scan() -> void:
	scan_line.visible = true
	scan_line.set("scan_progress", 0.0)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(scan_line, "scan_progress", 1.0, SCAN_TIME)
	tween.tween_callback(_on_scan_finished)


func _on_scan_finished() -> void:
	scan_line.visible = false
	_show_granted()


func _enter_main() -> void:
	get_tree().call_deferred("change_scene_to_file", MAIN_SCENE_PATH)


func _advance_gesture() -> void:
	gesture_index = (gesture_index + 1) % WAITING_GESTURES.size()
	gesture.texture = WAITING_GESTURES[gesture_index]


func _on_fade_finished() -> void:
	if not changing_scene:
		animation_timer.start(HOLD_TIME)
