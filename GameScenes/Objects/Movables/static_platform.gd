extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var area = $Area2D

func _on_area_2d_body_entered(body):
	collision.set_deferred("disabled", true)

func _on_area_2d_body_exited(body):
	collision.set_deferred("disabled", false)
	area.set_deferred("monitoring", false)
