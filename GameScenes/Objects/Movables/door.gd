extends AnimatableBody2D

enum BEHAVIOUR { MOVE_UP, MOVE_DOWN, DISAPPEAR }

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

## What the door should do upon triggering a switch.
@export var door_behaviour: BEHAVIOUR
## Determines if the door can return to its original position after triggering the switch again.
@export var door_can_return: bool
## How far the door should move away from its current location.
@export var distance: int 
## How long it takes in seconds for the door to reach its destination.
@export var move_duration: int

var activated := false 
var currently_moving := false
var original_position: Vector2

var objects_in_zone_counter := 0


func _ready() -> void:
	original_position = position


func _move(direction: Vector2) -> void:
	currently_moving = true
	var target_position: Vector2 = original_position if activated else original_position + direction
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_position, move_duration)
	tween.connect("finished", on_tween_finished)


func on_tween_finished() -> void:
	currently_moving = false


func _disappear() -> void:
	if (!activated):
		self.hide()
		collision_shape.call_deferred("set", "disabled", true)
	else:
		self.show()
		collision_shape.call_deferred("set", "disabled", false)


func _handle_signal() -> void:
	if not door_can_return and activated:
		return
	
	match door_behaviour:
		BEHAVIOUR.MOVE_UP:
			_move(Vector2(0, -distance))
		BEHAVIOUR.MOVE_DOWN:
			_move(Vector2(0, distance))
		BEHAVIOUR.DISAPPEAR:
			_disappear()
			
	activated = !activated


# The first object on the pressure plate should trigger it and no subsequent one
func _on_plate_switch_body_entered(_body: Node2D) -> void:
	objects_in_zone_counter += 1
	if objects_in_zone_counter == 1:
		_handle_signal()


# The last object to leave the pressure plate should reverse it
func _on_plate_switch_body_exited(_body: Node2D) -> void:
	objects_in_zone_counter -= 1
	if objects_in_zone_counter == 0 and door_can_return:
		_handle_signal()


func _on_toggle_switch_switch_toggled() -> void:
	if not currently_moving:
		_handle_signal()
