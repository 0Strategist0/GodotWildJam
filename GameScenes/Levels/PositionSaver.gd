extends Node

@onready var parent := get_parent()
@onready var old_pos : Vector2 = parent.position


func _ready() -> void:
	if (not Progress.object_positions.has(parent.owner.get_meta("level")) 
			or not Progress.object_positions[parent.owner.get_meta("level")].has(parent.name)):
		Progress.object_positions[parent.owner.get_meta("level")] = {parent.name: parent.position}
	
	parent.position = Progress.object_positions[parent.owner.get_meta("level")][parent.name]

func _physics_process(_delta: float) -> void:
	if old_pos != parent.position:
		Progress.object_positions[parent.owner.get_meta("level")][parent.name] = parent.position
	
	old_pos = parent.position
