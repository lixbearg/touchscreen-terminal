extends Control

@onready var map: Map = $MapViewPort/SubViewport/Map
@onready var zoom_slider: ZoomSlider = $ZoomSlider
@onready var buttons: Control = $Buttons
@onready var alarm_overlay: TextureRect = $AlarmOverlay
@onready var informations: Label = $Informations

var alarm_active : bool = false
var shields_active : bool = false


func _ready() -> void:
	zoom_slider.connect("zoom_value_changed", on_zoom_value_changed)
	var tween = create_tween()
	for button in buttons.get_children():
		button.connect("main_button_pressed", on_main_button_pressed)


func on_zoom_value_changed(value : float) -> void:
	map.change_zoom(lerp(9, 3, value))


func on_main_button_pressed(type : MainButton.ButtonType, index : int, toggle_on : bool):
	if type == MainButton.ButtonType.MAP and toggle_on:
		print(index)
		animate_informations_text()
	elif type == MainButton.ButtonType.ALARM:
		alarm_active = !alarm_active
		alarm_overlay.visible = alarm_active
		map.click_enabled = !alarm_active
	elif type == MainButton.ButtonType.SHIELDS:
		shields_active != shields_active


func animate_informations_text() -> void:
	informations.visible_ratio = 0.0
	var tween = create_tween()
	tween.tween_property(informations, "visible_ratio", 1.0, 3.0)
	
