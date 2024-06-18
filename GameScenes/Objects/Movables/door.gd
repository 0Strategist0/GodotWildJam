extends AnimatableBody2D

enum BEHAVIOUR { MOVE_UP, MOVE_DOWN, DISAPPEAR }

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var door_behaviour: BEHAVIOUR
@export var door_can_return: bool 

var activated := false 
var currently_moving := false
var original_position: Vector2

var objects_in_zone_counter := 0

const DISTANCE_UP := Vector2(0, -50)
const DISTANCE_DOWN := Vector2(0, 50)
const TIME_TO_MOVE := 1


func _ready() -> void:
	original_position = position


func _move(direction: Vector2) -> void:
	currently_moving = true
	var target_position: Vector2 = original_position if activated else original_position + direction
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", target_position, TIME_TO_MOVE)
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
	if currently_moving or (not door_can_return and activated):
		return
	
	match door_behaviour:
		BEHAVIOUR.MOVE_UP:
			_move(DISTANCE_UP)
		BEHAVIOUR.MOVE_DOWN:
			_move(DISTANCE_DOWN)
		BEHAVIOUR.DISAPPEAR:
			_disappear()
			
	activated = !activated


# The first object on the pressure plate should trigger it and no subsequent one
func _on_plate_switch_body_entered(body: Node2D) -> void:
	objects_in_zone_counter += 1
	if objects_in_zone_counter == 1:
		_handle_signal()


# The last object to leave the pressure plate should reverse it
func _on_plate_switch_body_exited(body: Node2D) -> void:
	objects_in_zone_counter -= 1
	if objects_in_zone_counter == 0 and door_can_return:
		currently_moving = false
		_handle_signal()


func _on_toggle_switch_switch_toggled() -> void:
	_handle_signal()
