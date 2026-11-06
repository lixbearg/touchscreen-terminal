extends Control

@onready var map: Map = $MapViewPort/SubViewport/Map
@onready var zoom_slider: ZoomSlider = $ZoomSlider
@onready var buttons: Control = $Buttons
@onready var alarm_overlay: TextureRect = $AlarmOverlay
@onready var informations: Label = $Informations
@onready var osc_server: OSCServer = $OSCServer
@onready var shields_button: MainButton = $Buttons/ShieldsButton
@onready var alarm_button: MainButton = $Buttons/AlarmButton
@onready var fade_overlay: ColorRect = $FadeOverlay

const SCENE_FADE_IN_TIME : float = 0.4
const SCENE_FADE_OUT_TIME : float = 0.4

var alarm_active : bool = false
var shields_active : bool = false

var alarm_texture_normal = preload("res://resources/images/buttons/button_alarm.png")
var alarm_texture_active = preload("res://resources/images/buttons/button_alarm_active.png")
var shields_texture_normal = preload("res://resources/images/buttons/button_shields.png")
var shields_texture_active = preload("res://resources/images/buttons/button_shields_active.png")

var text_tween : Tween

const SHIELDS_ON_ADDRESS : String = "/terminal/shields/on"
const SHIELDS_OFF_ADDRESS : String = "/terminal/shields/off"
const ALARM_ON_ADDRESS : String = "/terminal/alarm/on"
const ALARM_OFF_ADDRESS : String = "/terminal/alarm/off"

const IDENTIFICATION_SCENE_PATH : String = "res://scenes/identification.tscn"

var changing_scene : bool = false


func _ready() -> void:
	zoom_slider.connect("zoom_value_changed", _on_zoom_value_changed)
	osc_server.connect("message_received", _on_osc_server_message_received)
	for button in buttons.get_children():
		button.connect("main_button_pressed", _on_main_button_pressed)
	$InactivityTimer.timeout.connect(_on_inactivity_timeout)
	$InactivityTimer.start()
	_fade_in()


func _fade_in() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 0.0, SCENE_FADE_IN_TIME)
	tween.tween_callback(_hide_fade_overlay)


func _hide_fade_overlay() -> void:
	fade_overlay.visible = false


func _input(event : InputEvent) -> void:
	if _is_activity_event(event):
		$InactivityTimer.start()


func _is_activity_event(event : InputEvent) -> bool:
	if event is InputEventMouseButton:
		return event.pressed
	if event is InputEventScreenTouch:
		return event.pressed
	if event is InputEventKey:
		return event.pressed and not event.echo
	if event is InputEventJoypadButton:
		return event.pressed
	return false


func _on_inactivity_timeout() -> void:
	if changing_scene:
		return

	changing_scene = true
	_fade_out_to_identification()


func _fade_out_to_identification() -> void:
	fade_overlay.visible = true
	fade_overlay.modulate.a = 0.0

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, SCENE_FADE_OUT_TIME)
	tween.tween_callback(_change_to_identification)


func _change_to_identification() -> void:
	get_tree().call_deferred("change_scene_to_file", IDENTIFICATION_SCENE_PATH)


func _on_zoom_value_changed(value : float) -> void:
	map.change_zoom(lerp(9, 3, value))


func _on_osc_server_message_received(address, value, time) -> void:
	match address:
		SHIELDS_ON_ADDRESS:
			shields_active = true
			shields_button.texture_normal = shields_texture_active
		SHIELDS_OFF_ADDRESS:
			shields_active = false
			shields_button.texture_normal = shields_texture_normal
		ALARM_ON_ADDRESS:
			alarm_button.texture_normal = alarm_texture_active
			alarm_active = true
		ALARM_OFF_ADDRESS:
			alarm_button.texture_normal = alarm_texture_normal
			alarm_active = false
	alarm_overlay.visible = alarm_active
	map.click_enabled = !alarm_active


func _on_main_button_pressed(type : MainButton.ButtonType, index : int, toggle_on : bool):
	if type == MainButton.ButtonType.MAP and toggle_on:
		map.change_map(index)
		informations.text = Strings.INFORMATIONS[index]
		animate_informations_text()


func animate_informations_text() -> void:
	informations.visible_ratio = 0.0
	if text_tween and text_tween.is_valid():
		text_tween.kill()
	text_tween = create_tween()
	text_tween.tween_property(informations, "visible_ratio", 1.0, 3.0)
	
