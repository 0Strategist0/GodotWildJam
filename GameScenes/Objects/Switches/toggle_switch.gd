extends Area2D


@onready var interaction_area: InteractionArea = $InteractionArea


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	# There should be a signal here that gets sent out
	print("switch")
