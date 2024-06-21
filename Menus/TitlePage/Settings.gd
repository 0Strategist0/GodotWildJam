extends PanelContainer


func _on_options_button_pressed() -> void:
	visible = true


func _on_fog_check_toggled(toggled_on: bool) -> void:
	Settings.fog = toggled_on


func _on_exit_pressed() -> void:
	visible = false
