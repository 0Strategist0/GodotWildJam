extends Marker2D


@onready var star: Polygon2D = $Polygon2D
@onready var pink_marker: Sprite2D = $Sprite2D

const ROTATION_SPEED := 0.05


func _ready() -> void:
	pink_marker.hide()


func _process(_delta: float) -> void:
	star.rotate(ROTATION_SPEED)
