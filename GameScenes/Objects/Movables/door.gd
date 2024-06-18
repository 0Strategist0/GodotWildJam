extends AnimatableBody2D

enum BEHAVIOUR { MOVE_UP, MOVE_DOWN, DISAPPEAR }

@export var door_behaviour: BEHAVIOUR
@export var door_can_return: bool 

var activated := false 
var currently_moving := false

const DISTANCE_TO_MOVE := Vector2(0, -50)
const TIME_TO_MOVE := 0.5


func _move_up() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", position + DISTANCE_TO_MOVE, TIME_TO_MOVE)
	tween.connect("finished", on_tween_finished)


func _move_down() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0,50), TIME_TO_MOVE)
	tween.connect("finished", on_tween_finished)


func on_tween_finished() -> void:
	currently_moving = false


func _disappear() -> void:
	self.visible = not activated


func _handle_signal() -> void:
	if currently_moving or (!door_can_return and activated):
		return
	
	currently_moving = true
	activated = true
	
	match door_behaviour:
		BEHAVIOUR.MOVE_UP:
			_move_up()
		BEHAVIOUR.MOVE_DOWN:
			_move_down()
		BEHAVIOUR.DISAPPEAR:
			_disappear()


func _on_plate_switch_body_entered(body: Node2D) -> void:
	_handle_signal()
