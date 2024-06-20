extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var lever_sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: Sprite2D = $Sprite2D
@export var lever_number: int
@export var single_use: bool

var in_use := false
var activated := false
var original_rotation: float
var tween: Tween
var enabled := true


signal lever_toggled(number: int)


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	original_rotation = sprite.rotation


func _on_interact() -> void:
	if enabled and ((single_use and !activated) or !single_use):
		if in_use:
			# TODO: play a rejection sound
			return
		
		in_use = true
		activated = !activated
		
		lever_toggled.emit(lever_number)
		lever_sfx.play()
		
		flip_lever(activated)

func flip_lever(on: bool) -> void:
	# Change the rotation of the handle
	tween = create_tween()
	if on:
		tween.tween_property(sprite, "rotation", original_rotation * -1, 0.2)
	else:
		tween.tween_property(sprite, "rotation", original_rotation, 0.2)
	tween.connect("finished", on_tween_finished)

func on_tween_finished() -> void:
	in_use = false
