extends Button

const WORLD := preload("uid://cp08dx7in60dn")
const UI := preload("uid://b5kvf0loq0rxl")

@onready var main := GlobalNodeReferences.main
@onready var title_page := get_node("../..")

func _on_pressed():
	var world := WORLD.instantiate()
	var ui := UI.instantiate()
	
	main.add_child(world)
	main.add_child(ui)
	
	title_page.queue_free()
