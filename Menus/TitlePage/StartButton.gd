extends Button

const WORLD := preload("uid://cp08dx7in60dn")
const LEVEL1 := preload("uid://b0kxtk2p027ml")
const UI := preload("uid://b5kvf0loq0rxl")
#const SIMON := preload("uid://c4c0m1vjycehs")
const A1 := preload("uid://b757fjeorrns1")

@onready var main := GlobalNodeReferences.main
@onready var title_page := get_node("../..")
@onready var arrow_label := $Label

# Remove this later
var debug_mode := 2

func _on_pressed() -> void:
	var world := WORLD.instantiate()
	var level := LEVEL1.instantiate()
	var ui := UI.instantiate()
	#var simon := SIMON.instantiate()
	var a1 := A1.instantiate()
	
	match debug_mode:
		1:
			main.add_child(world)
		2:
			main.add_child(level)
		3:
			pass
			#main.add_child(simon)
		4:
			main.add_child(a1)
	main.add_child(ui)
	
	title_page.queue_free()


func _on_mouse_entered() -> void:
	arrow_label.visible = true


func _on_mouse_exited() -> void:
	arrow_label.visible = false


func _on_focus_entered() -> void:
	arrow_label.visible = true


func _on_focus_exited() -> void:
	arrow_label.visible = false
