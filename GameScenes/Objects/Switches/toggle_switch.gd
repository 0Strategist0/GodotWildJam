extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var toggle_sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: Sprite2D = $Sprite2D

var in_use := false
var activated := false
var original_rotation: int
var tween: Tween


signal switch_toggled()


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	if in_use:
		# TODO: play a rejection sound
		return
	
	in_use = true
	activated = !activated
	
	switch_toggled.emit()
	toggle_sfx.play()

	# Change the rotation of the handle
	tween = create_tween()
	tween.tween_property(sprite, "rotation", sprite.rotation * -1, 0.2)
	tween.connect("finished", on_tween_finished)


func on_tween_finished() -> void:
	in_use = false
