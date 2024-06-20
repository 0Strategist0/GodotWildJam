extends Area2D


func _on_trigger_hunt_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		$AnimationPlayer.play("Hunt")


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("kill"):
		body.kill()
