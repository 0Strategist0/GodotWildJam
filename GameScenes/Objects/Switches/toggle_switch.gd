extends Area2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var toggle_sfx: AudioStreamPlayer = $AudioStreamPlayer

signal switch_toggled()

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	switch_toggled.emit()
	toggle_sfx.play()
