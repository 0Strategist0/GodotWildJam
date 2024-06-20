extends Area2D


@onready var interaction_area: InteractionArea = $InteractionArea
@export var switch_number: int
@onready var toggle_sfx: AudioStreamPlayer = $AudioStreamPlayer

signal switch_toggled(number: int)

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	switch_toggled.emit(switch_number)
	#print("switch")
	toggle_sfx.play()
