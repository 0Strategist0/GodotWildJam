const lines: Array[String] = [
	"Hello, this is a test.",
	"Can you hear me...?",
	"LA LA LA LA LA LA!!!",
	"Ok, it was nice to meet you."
]


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if interaction_area.get_overlapping_bodies().size() > 0:
			DialogManager.start_dialog(global_position, lines)
