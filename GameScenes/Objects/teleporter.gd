extends Area2D

@export var teleport_location: Marker2D

@onready var main := GlobalNodeReferences.main

# Teleports the user to the set Marker2D
func _on_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		body.position = teleport_location.global_position 
