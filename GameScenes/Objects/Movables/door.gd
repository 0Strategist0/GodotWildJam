extends AnimatableBody2D

enum BEHAVIOUR { MOVE_UP, MOVE_DOWN, DISAPPEAR }

@export var door_behaviour: BEHAVIOUR
@export var door_can_return: bool 

var activated := false 
var currently_moving := false
var original_position: Vector2

const DISTANCE_TO_MOVE := Vector2(0, -50)
const TIME_TO_MOVE := 0.5


func _ready() -> void:
	original_position = position


func _move_up() -> void:
	currently_moving = true
	var target_position = original_position if activated else original_position + DISTANCE_TO_MOVE
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, TIME_TO_MOVE)
	tween.connect("finished", on_tween_finished)


func _move_down() -> void:
	currently_moving = true
	var target_position = original_position if activated else original_position + DISTANCE_TO_MOVE
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0,50), TIME_TO_MOVE)
	tween.connect("finished", on_tween_finished)


func on_tween_finished() -> void:
	currently_moving = false


func _disappear() -> void:
	if (!activated):
		self.hide()
	else:
		self.show()


func _handle_signal() -> void:
	if currently_moving or (not door_can_return and activated):
		return
	
	match door_behaviour:
		BEHAVIOUR.MOVE_UP:
			_move_up()
		BEHAVIOUR.MOVE_DOWN:
			_move_down()
		BEHAVIOUR.DISAPPEAR:
			_disappear()
			
	activated = !activated


func _on_plate_switch_body_entered(body: Node2D) -> void:
	_handle_signal()
