extends Area2D

# When placing this, use the teleport_location.tscn in Objects/Teleporter path
@export var teleport_location: Marker2D

@onready var teleport_sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var main := GlobalNodeReferences.main

# Teleports the user to the set Marker2D
func _on_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		teleport_sfx.play()
		body.position = teleport_location.global_position 
