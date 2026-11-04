class_name ScanLine
extends Control

var scan_area := PackedVector2Array([
	Vector2(55.0, 1130.0),
	Vector2(175.0, 574.0),
	Vector2(904.0, 574.0),
	Vector2(1024.0, 1130.0),
	Vector2(901.0, 1862.0),
	Vector2(178.0, 1862.0),
])

const SCAN_TOP : float = 600.0
const SCAN_BOTTOM : float = 1840.0
const EDGE_INSET : float = 4.0

@export_range(0.0, 1.0) var scan_progress : float = 0.0:
	set(value):
		scan_progress = clampf(value, 0.0, 1.0)
		queue_redraw()


func _draw() -> void:
	var y := lerpf(SCAN_TOP, SCAN_BOTTOM, scan_progress)
	var segment := _scan_segment(y)
	if segment.is_empty():
		return

	var start := segment[0]
	var end := segment[1]
	start.x += EDGE_INSET
	end.x -= EDGE_INSET
	if end.x <= start.x:
		return

	draw_line(start, end, Color(1.0, 0.45, 0.1, 0.06), 34.0, true)
	draw_line(start, end, Color(1.0, 0.55, 0.15, 0.16), 16.0, true)
	draw_line(start, end, Color(1.0, 0.75, 0.4, 0.85), 4.0, true)
	draw_line(start, end, Color(1.0, 0.97, 0.9, 1.0), 1.5, true)


func _scan_segment(y : float) -> PackedVector2Array:
	var intersections := Geometry2D.intersect_polyline_with_polygon(
		PackedVector2Array([Vector2(-1.0, y), Vector2(size.x + 1.0, y)]),
		scan_area
	)
	if intersections.is_empty():
		return PackedVector2Array()

	var points : PackedVector2Array = intersections[0]
	if points.size() < 2:
		return PackedVector2Array()

	var start := points[0]
	var end := points[points.size() - 1]
	if start.x > end.x:
		var temp := start
		start = end
		end = temp

	return PackedVector2Array([start, end])
