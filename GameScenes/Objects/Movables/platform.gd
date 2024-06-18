extends AnimatableBody2D

@export var continuous := true
@export var requires_signal := false
## The time in seconds it takes to reach a single point.
@export var duration: int
## An array of markers that the platform will travel to. Requires at least 2 points.
@export var points: Array[Marker2D] = []

@export var distance: Vector2

var objects_in_zone_counter: int
var currently_moving: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if is_connected() set requires_signal to true
	#assert(points.size() > 1, "Platform must have at least 2 points!")
	
	if continuous:
		currently_moving = true
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", distance, duration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _move() -> void:
	pass


func _on_plate_switch_body_entered(_body: Node2D) -> void:
	objects_in_zone_counter += 1
	if objects_in_zone_counter == 1:
		_move()


func _on_plate_switch_body_exited(_body: Node2D) -> void:
	objects_in_zone_counter -= 1
	if objects_in_zone_counter == 0:
		_move()


func _on_toggle_switch_toggled() -> void:
	if not currently_moving:
		_move() 
