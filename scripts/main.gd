extends Control

@onready var map: Map = $MapViewPort/SubViewport/Map
@onready var zoom_slider: ZoomSlider = $ZoomSlider
@onready var buttons: Control = $Buttons
@onready var alarm_overlay: TextureRect = $AlarmOverlay
@onready var informations: Label = $Informations
@onready var osc_server: OSCServer = $OSCServer
@onready var shields_button: MainButton = $Buttons/ShieldsButton
@onready var alarm_button: MainButton = $Buttons/AlarmButton

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


func _ready() -> void:
	zoom_slider.connect("zoom_value_changed", _on_zoom_value_changed)
	osc_server.connect("message_received", _on_osc_server_message_received)
	for button in buttons.get_children():
		button.connect("main_button_pressed", _on_main_button_pressed)


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
	
