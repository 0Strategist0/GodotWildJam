extends AnimatableBody2D

@export var continuous: bool
@export var distance: Vector2
@export var duration: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", position + distance, duration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
