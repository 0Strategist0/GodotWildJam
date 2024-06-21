extends Area2D

@onready var plate_sfx: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: Sprite2D = $Sprite2D

var objects_inside_body := 0
var original_position: Vector2


func _ready() -> void:
	original_position = sprite.position


func _on_body_entered(_body: Node2D) -> void:
	objects_inside_body += 1
	if objects_inside_body == 1:
		plate_sfx.play()
		var tween: Tween = create_tween()
		tween.tween_property(sprite, "position", sprite.position + Vector2(0, 4), 0.1)


func _on_body_exited(_body: Node2D) -> void:
	objects_inside_body -= 1
	if objects_inside_body == 0:
		var tween: Tween = create_tween()
		tween.tween_property(sprite, "position", original_position, 0.1)
