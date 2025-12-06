extends Button

@onready var map: Map = $"../MapViewPort/SubViewport/Map"


var rotating : bool = false
var prev_mouse_pos : Vector2
var next_mouse_pos : Vector2


#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	#if event is InputEventMouseMotion:
		#print("foi")
	#if (event.is_action_pressed("Rotate")):
		#rotating = true
		#prev_mouse_pos = get_viewport().get_mouse_position()
	#if (Input.is_action_just_released("Rotate")):
		#rotating = false
#
	#if (rotating):
		#next_mouse_pos = get_viewport().get_mouse_position()
		#var x_amount = ((next_mouse_pos.y - prev_mouse_pos.y) * .2)
		#var y_amount = ((next_mouse_pos.x - prev_mouse_pos.x) * .2)
		#map.rotate_model(x_amount, y_amount)
		#prev_mouse_pos = next_mouse_pos


func _on_pressed() -> void:
	prev_mouse_pos = get_viewport().get_mouse_position()
	var x_amount = ((next_mouse_pos.y - prev_mouse_pos.y) * .2)
	var y_amount = ((next_mouse_pos.x - prev_mouse_pos.x) * .2)
	map.rotate_model(x_amount, y_amount)
