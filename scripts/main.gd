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
		SHIELDS_OFF_ADDRESS:
			shields_active = false
		ALARM_ON_ADDRESS:
			alarm_active = true
		ALARM_OFF_ADDRESS:
			alarm_active = false
	update_buttons_status()


func update_buttons_status() -> void:
	shields_button.set_pressed_no_signal(shields_active)
	alarm_button.set_pressed_no_signal(alarm_active)
	alarm_overlay.visible = alarm_active
	map.click_enabled = !alarm_active


func _on_main_button_pressed(type : MainButton.ButtonType, index : int, toggle_on : bool):
	if type == MainButton.ButtonType.MAP and toggle_on:
		print(index)
		animate_informations_text()


func animate_informations_text() -> void:
	informations.visible_ratio = 0.0
	var tween = create_tween()
	tween.tween_property(informations, "visible_ratio", 1.0, 3.0)
	
