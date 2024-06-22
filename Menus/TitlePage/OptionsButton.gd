extends Button

@onready var arrow_label := $Label

func _on_mouse_entered() -> void:
	arrow_label.visible = true


func _on_mouse_exited() -> void:
	arrow_label.visible = false


func _on_focus_entered() -> void:
	arrow_label.visible = true


func _on_focus_exited() -> void:
	arrow_label.visible = false
