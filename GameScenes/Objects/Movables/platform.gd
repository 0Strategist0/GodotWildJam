extends AnimatableBody2D

## If there is no switch, the platform will move on its own.
@export var uses_switch: bool = false
## An array of markers that the platform will travel to. The platform's original position will be included in the rotation of points.
@export var points: Array[Marker2D] = []
## How fast the platform should move.
@export var speed: int = 50

var movable: bool = true
var objects_in_zone_counter: int = 0

# Variables used for moving calculation
var activated: bool = false
var currently_moving: bool = false
var next_point_idx: int = 0


func _ready() -> void:
	var original_position := Marker2D.new()
	original_position.position = position
	points.insert(0, original_position)
	movable = (points.size() != 0)


func _process(_delta: float) -> void:
	if not uses_switch or activated:
		_move()


func _move() -> void:
	if not currently_moving and movable:
		currently_moving = true
		_move_to_next_point()


func _move_to_next_point() -> void:
	# This is needed to resolve a crash when creating tween when not in tree
	if not is_inside_tree():
		return

	# Find next position to move towards
	next_point_idx += 1
	next_point_idx %= points.size()
	var target_position := points[next_point_idx].position
	
	# Calculate speed to keep movement consistent
	var tween_distance := position.distance_to(target_position)
	var tween_time := tween_distance / speed
	
	# Create tween to move to desired location
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", points[next_point_idx].position, tween_time)
	tween.connect("finished", on_tween_finished)


func on_tween_finished() -> void:
	currently_moving = false


func _on_plate_switch_body_entered(_body: Node2D) -> void:
	objects_in_zone_counter += 1
	if objects_in_zone_counter == 1:
		activated = true


func _on_plate_switch_body_exited(_body: Node2D) -> void:
	objects_in_zone_counter -= 1
	if objects_in_zone_counter == 0:
		activated = false


func _on_lever_switch_lever_toggled(_number: int) -> void:
	activated = !activated
