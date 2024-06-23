extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var speech_sound: AudioStream = preload("res://GameScenes/NPCs/adult_voice.wav")

@export var adult_num := 1
@export var flip_sprite := false

const lines_1: Array[String] = [
	"You've been chosen as the sacrifice, huh?",
	"Tough luck",
	"Well, it had to be someone",
	"Meet the rest of us over by the cliff side"
]

const lines_2: Array[String] = [
	"I've been stuck here for a while now",
	"Can't seem to get this jump..."
]

const lines_3: Array[String] = [
	"This is so exciting! I'm new here, but...",
	"I heard the sacrifice happens every decade",
	"It's my first time seeing it!!!",
	"Oh wait, it's you? umm... sorry."
]

const lines_4: Array[String] = [
	"We're not really sure why it wants kids",
	"but who are we to argue?",
	"I heard once we offered an adult...",
	"and the whole village burned down"
]

const lines_5: Array[String] = [
	"Hurry up and get to the edge",
	"We don't want to be late",
	"...what",
	"Stop wasting my time"
]

const lines_6: Array[String] = [
	"You're so young...",
	"I'm sorry, child"
]

const lines_7: Array[String] = [
	"I knew the last kid that went in",
	"wonder how he's doing",
	"Probably poop now or something"
]

const lines_8: Array[String] = [
	"You look nervous",
	"Don't worry!",
	"It will all be over soon..."
]

const lines_9: Array[String] = [
	"ohmygod ohmygod ohmygod",
	"please hurry and jump!!!",
	"it'll get mad at us"
]

const lines_10: Array[String] = [
	"You're here",
	"Move to the very edge and we can start",
	"I'm sorry"
]


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	assert(adult_num > 0 and adult_num <= 10, "There should only be 1-10 adults.")
	
	if flip_sprite:
		self.scale = Vector2(-1,1)


func _on_interact() -> void:
	match adult_num:
		1:
			DialogManager.start_dialog(global_position, lines_1, speech_sound)
		2:
			DialogManager.start_dialog(global_position, lines_2, speech_sound)
		3:
			DialogManager.start_dialog(global_position, lines_3, speech_sound)
		4:
			DialogManager.start_dialog(global_position, lines_4, speech_sound)
		5:
			DialogManager.start_dialog(global_position, lines_5, speech_sound)
		6:
			DialogManager.start_dialog(global_position, lines_6, speech_sound)
		7:
			DialogManager.start_dialog(global_position, lines_7, speech_sound)
		8:
			DialogManager.start_dialog(global_position, lines_8, speech_sound)
		9:
			DialogManager.start_dialog(global_position, lines_9, speech_sound)
		10:
			DialogManager.start_dialog(global_position, lines_10, speech_sound)
