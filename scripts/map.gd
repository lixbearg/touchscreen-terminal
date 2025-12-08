class_name Map
extends Node3D

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D

var rotating : bool = false
var prev_mouse_pos : Vector2
var next_mouse_pos : Vector2
const CLICKABLE_AREA = Rect2(Vector2(-105, -132), Vector2(950, 750))  


func rotate_model(x_amount : float, y_amount : float) -> void:
	rigid_body_3d.rotate_x(x_amount)
	rigid_body_3d.rotate_y(y_amount)


func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Rotate") and inside_clickable_area()):
		rotating = true
		prev_mouse_pos = get_viewport().get_mouse_position()
	if (Input.is_action_just_released("Rotate")):
		rotating = false
		
	if (rotating):
		next_mouse_pos = get_viewport().get_mouse_position()
		rigid_body_3d.rotate_y((next_mouse_pos.x - prev_mouse_pos.x) * .2 * delta)
		rigid_body_3d.rotate_x((next_mouse_pos.y - prev_mouse_pos.y) * .2 * delta)
		prev_mouse_pos = next_mouse_pos
	else:		
		rigid_body_3d.rotate_y(.1 * delta)
		#if rotation.x != 0:
			#rotate_x(move_toward(rotation.x, 0, .001))


func inside_clickable_area():
	return CLICKABLE_AREA.has_point(get_viewport().get_mouse_position())
