extends Control

@onready var map: Map = $MapViewPort/SubViewport/Map
@onready var zoom_slider: ZoomSlider = $ZoomSlider


func _ready() -> void:
	zoom_slider.connect("zoom_value_changed", on_zoom_value_changed)


func on_zoom_value_changed(value : float) -> void:
	map.change_zoom(lerp(9, 3, value))
