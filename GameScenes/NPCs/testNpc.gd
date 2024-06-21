extends CharacterBody2D


@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound: AudioStream = preload("res://GameScenes/NPCs/adult_voice.wav")

const lines: Array[String] = [
	"hello this is a test",
	"can you hear me...",
	"LA LA LA LA LA LA",
	"ok it was nice to meet you"
]


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")


func _on_interact() -> void:
	DialogManager.start_dialog(global_position, lines, speech_sound)
