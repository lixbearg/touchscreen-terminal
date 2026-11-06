extends AudioStreamPlayer

const BGM_STREAM : AudioStream = preload("res://resources/sfx/Computer Drone 2C.wav")


func _ready() -> void:
	# Keep the music running even if the scene tree is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	stream = BGM_STREAM
	play()
