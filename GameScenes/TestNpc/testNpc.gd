extends CharacterBody2D


@onready var interaction_area: InteractionArea = $InteractionArea


const lines: Array[String] = [
	"Hello, this is a test.",
	"Can you hear me...?",
	"LA LA LA LA LA LA!!!",
	"Ok, it was nice to meet you."
]


func _ready():
	print("ready")
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact():
	print("on interact")
	DialogManager.start_dialog(global_position, lines)
	await DialogManager.is_dialog_active == false
