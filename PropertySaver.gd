extends Node

@export var variables_to_save : Array[String] = []

@onready var parent := get_parent()


func _ready() -> void:
	if (not Progress.object_variables.has(parent.owner.get_meta("level")) 
			or not Progress.object_variables[parent.owner.get_meta("level")].has(parent.name)):
		var variables := {}
		for var_name: String in variables_to_save:
			variables[var_name] = parent.get(var_name)
		Progress.object_variables[parent.owner.get_meta("level")][parent.name] = variables
	
	for var_name: String in variables_to_save:
		parent.set(var_name, Progress.object_variables[parent.owner.get_meta("level")][parent.name][var_name])

func _physics_process(_delta: float) -> void:
	for var_name: String in variables_to_save:
		Progress.object_variables[parent.owner.get_meta("level")][parent.name][var_name] = parent.get(var_name)
