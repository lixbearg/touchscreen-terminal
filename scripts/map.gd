class_name Map
extends Node3D

@onready var map_container: Node3D = $MapContainer
@onready var map_model: RigidBody3D = $MapContainer/MapModel
@onready var map_rotate_sfx: AudioStreamPlayer = $MapRotateSFX
@onready var camera_3d: Camera3D = $Camera3D

var rotating : bool = false
var prev_mouse_pos : Vector2
var next_mouse_pos : Vector2
var click_enabled : bool = true

var map_model_0 = preload("res://scenes/map_models/map_model_0.tscn")
var map_model_1 = preload("res://scenes/map_models/map_model_1.tscn")

const CLICKABLE_AREA = Rect2(Vector2(-105, -132), Vector2(950, 750))  


func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Rotate") and inside_clickable_area()):
		rotating = true
		prev_mouse_pos = get_viewport().get_mouse_position()
	if (Input.is_action_just_released("Rotate")):
		rotating = false
	
	if (rotating):
		# Get the current mouse position
		next_mouse_pos = get_viewport().get_mouse_position()

		# Calculate mouse movement deltas
		var delta_x = next_mouse_pos.y - prev_mouse_pos.y
		var delta_y = next_mouse_pos.x - prev_mouse_pos.x

		# Apply limits to X-axis rotation
		var new_container_rotation = map_container.rotation_degrees
		var new_model_rotation = map_model.rotation_degrees
		new_container_rotation.x = clamp(new_container_rotation.x, 20, 45)  # Limit X-axis to -45 to 45 degrees
		new_model_rotation.y += delta_y * 0.1  # Increase or decrease sensitivity here

		# Allow free rotation around the Y-axis
		new_container_rotation.x += delta_x * 0.1  # Increase or decrease sensitivity here

		# Lock the Z-axis rotation (ensure it's always 0)
		new_container_rotation.z = 0
		new_model_rotation.z = 0

		# Apply the updated rotation
		map_container.rotation_degrees = new_container_rotation
		map_model.rotation_degrees = new_model_rotation

		# Update previous mouse position
		prev_mouse_pos = next_mouse_pos

		# Play sound effect
		if not map_rotate_sfx.playing:
			map_rotate_sfx.play()
	else:
		# Stop sound effect if playing
		if map_rotate_sfx.playing:
			map_rotate_sfx.stop()
		
		# Add optional idle rotation behavior if desired (uncomment below)
		map_model.rotate_object_local(Vector3(0, 1, 0), .1 * delta)


func change_zoom(value : float) -> void:
	camera_3d.size = value


func inside_clickable_area():
	return CLICKABLE_AREA.has_point(get_viewport().get_mouse_position()) and click_enabled


func change_map(index : int) -> void:
	var new_map := load("res://scenes/map_models/map_model_" + str(index) + ".tscn")
	var new_map_instance = new_map.instantiate()
	var map_rotation = map_model.rotation
	map_model.queue_free()
	map_container.add_child(new_map_instance)
	new_map_instance.rotation = map_rotation
	#new_map_instance.origin = Vector3(0,0,0)
	new_map_instance.name = "MapModel"
	map_model = new_map_instance
