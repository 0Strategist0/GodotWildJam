extends Area2D


@onready var interaction_area: InteractionArea = $InteractionArea

signal switch_toggled()

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	switch_toggled.emit()
	print("switch")
