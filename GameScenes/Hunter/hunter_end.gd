extends Area2D



func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if body == GlobalNodeReferences.character:
		body.kill()
	
	elif body.is_in_group("heavy"):
		print("hello?")
		$"../TrueEnding".play("TrueEnding")
