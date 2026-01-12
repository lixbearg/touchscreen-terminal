extends Control

@onready var time_label: Label = $TimeLabel
@onready var date_label: Label = $DateLabel
@onready var random_label: Label = $RandomLabel
#@onready var timer: Timer = $Timer
@onready var random_timer: Timer = $RandomTimer
var initial_time = 0123485937

func _on_clock_timer_timeout() -> void:
	var time = Time.get_time_string_from_system()
	var date = Time.get_date_string_from_system()
	time_label.text = time
	date_label.text = date


func _on_random_timer_timeout() -> void:
	initial_time += 9
	random_label.text = str(initial_time)
