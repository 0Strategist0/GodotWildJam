extends Area2D

@export var next_level: PackedScene

@onready var main := GlobalNodeReferences.main

# Move the player to specified scene when coming in contact with collision shape 
func _on_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		HunterSignalling.end_hunt.emit()
		main.call_deferred("add_child", next_level.instantiate())
		owner.call_deferred("queue_free")
