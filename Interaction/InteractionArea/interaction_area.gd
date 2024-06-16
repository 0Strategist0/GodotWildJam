extends Area2D
class_name InteractionArea


@export var action_name: String = "Interact"


var interact: Callable = func() -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		InteractionManager.unregister_area(self)
