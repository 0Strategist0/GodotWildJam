extends MarginContainer


@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $LetterDisplayTimer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


const MAX_WIDTH = 256

var text: String = ""
var letter_index: int = 0

var letter_time: float = 0.02
var space_time: float = 0.03
var punctuation_time: float = 0.1


signal finished_displaying()


func display_text(text_to_display: String, speech_sfx: AudioStream) -> void:
	text = text_to_display
	label.text = text_to_display
	audio_player.stream = speech_sfx
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # await for x resize
		await resized # await for y resize
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= (size.y + 42)*scale.y
	
	label.text = ""
	_display_letter()


func _display_letter() -> void:
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	
	
	match text[letter_index]:
		".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
			var new_audio_player: AudioStreamPlayer = audio_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
