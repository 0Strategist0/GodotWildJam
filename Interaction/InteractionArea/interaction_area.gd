extends Area2D
class_name InteractionArea


@export var action_name: String = "Interact"


var interact: Callable = func():
	pass


func _on_body_entered(body):
	if body.name == "Character":
		InteractionManager.register_area(self)


func _on_body_exited(body):
	if body.name == "Character":
		InteractionManager.unregister_area(self)
