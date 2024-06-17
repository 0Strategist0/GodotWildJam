extends Area2D

@export var next_level: PackedScene

@onready var main := GlobalNodeReferences.main

# Move the player to specified scene when coming in contact with collision shape 
func _on_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		var new_scene := next_level.instantiate()
		main.add_child(new_scene)
		owner.queue_free()
