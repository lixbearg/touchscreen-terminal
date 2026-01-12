class_name ZoomSlider
extends Control

signal zoom_value_changed(float)

@onready var slider: VSlider = $Slider
@onready var sfx: AudioStreamPlayer = $SFX


func _on_slider_drag_started() -> void:
	sfx.play()


func _on_slider_drag_ended(value_changed: bool) -> void:
	sfx.stop()


func _on_slider_value_changed(value: float) -> void:
	sfx.pitch_scale = value * 3
	zoom_value_changed.emit(value)
