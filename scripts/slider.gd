extends VSlider

@onready var sfx: AudioStreamPlayer = $"../SFX"


func _on_drag_started() -> void:
	sfx.play()


func _on_drag_ended(value_changed: bool) -> void:
	sfx.stop()


func _on_value_changed(value: float) -> void:
	sfx.pitch_scale = value * 0.03
