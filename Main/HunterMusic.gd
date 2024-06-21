extends AudioStreamPlayer

func _ready() -> void:
	HunterSignalling.start_hunt.connect(start_hunt)
	HunterSignalling.end_hunt.connect(end_hunt)


func start_hunt() -> void:
	volume_db = -5.0
	play(0.5)

func end_hunt() -> void:
	if playing:
		$FadeOut.play("FadeOut")
