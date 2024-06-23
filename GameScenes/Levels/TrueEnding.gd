extends AnimationPlayer

func _start_again() -> void:
	get_tree().change_scene_to_file("res://Main/main.tscn")
