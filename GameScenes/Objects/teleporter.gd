extends Area2D

@export var teleport_location: Marker2D

@onready var main := GlobalNodeReferences.main

func _on_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		body.position = teleport_location.global_position 
