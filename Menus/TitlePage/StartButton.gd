extends Button

const WORLD := preload("uid://cp08dx7in60dn")
const LEVEL1 := preload("uid://b0kxtk2p027ml")
const UI := preload("uid://b5kvf0loq0rxl")

@onready var main := GlobalNodeReferences.main
@onready var title_page := get_node("../..")

# Remove this later
var debug_mode := false

func _on_pressed() -> void:
	var world := WORLD.instantiate()
	var level := LEVEL1.instantiate()
	var ui := UI.instantiate()
	
	if debug_mode:
		main.add_child(world)
	else:
		main.add_child(level)
	main.add_child(ui)
	
	title_page.queue_free()
