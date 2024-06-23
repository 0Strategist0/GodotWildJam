extends Control

const FIRST_SCENE := preload("uid://b0kxtk2p027ml")

func _on_young_button_pressed() -> void:
	CharacterAttributes.small = true
	CharacterAttributes.fat = false
	CharacterAttributes.fast = false
	CharacterAttributes.strong = false


func _on_large_button_pressed() -> void:
	CharacterAttributes.small = false
	CharacterAttributes.fat = true
	CharacterAttributes.fast = false
	CharacterAttributes.strong = false


func _on_fast_button_pressed() -> void:
	CharacterAttributes.small = false
	CharacterAttributes.fat = false
	CharacterAttributes.fast = true
	CharacterAttributes.strong = false


func _on_strong_pressed() -> void:
	CharacterAttributes.small = false
	CharacterAttributes.fat = false
	CharacterAttributes.fast = false
	CharacterAttributes.strong = true


func _on_button_pressed() -> void:
	$FadeIn.play("FadeOut")
	CharacterAttributes.randomize_hair()
	var scene : Node2D = FIRST_SCENE.instantiate()
	GlobalNodeReferences.main.call_deferred("add_child", scene)
	queue_free()
