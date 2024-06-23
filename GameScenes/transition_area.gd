extends Area2D

@export var next_level_uid: String
@export var load_position: Vector2

@onready var main := GlobalNodeReferences.main

# Move the player to specified scene when coming in contact with collision shape 
func _on_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		print("hello")
		HunterSignalling.end_hunt.emit()
		
		# Play fade animation
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		
		# Move to next scene
		var next_scene : Node2D = load(next_level_uid).instantiate()
		if load_position != Vector2.ZERO:
			next_scene.get_node("Character").position = load_position
		main.call_deferred("add_child", next_scene)
		
		owner.call_deferred("queue_free")
