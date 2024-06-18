extends Node2D

const DEAD_CHARACTER_SCENE := preload("uid://caicj44ceb3on")

func _ready() -> void:
	
	var bodies : Dictionary = (Progress.bodies[get_meta("level")] 
			if Progress.bodies.has(get_meta("level")) else {})
	
	# Spawn each body in the correct place and direction
	for location: Vector2 in bodies.keys():
		var new_body := DEAD_CHARACTER_SCENE.instantiate()
		var direction : float = bodies[location].direction
		var hair_type : int = bodies[location].type
		for child in new_body.get_children():
			if child.get_class() == "Node2D":
				child.scale.x = direction
				for hair in child.find_children("Hair?"):
					if str(hair_type) in hair.name:
						hair.visible = true
					else:
						hair.visible = false
			elif child is CollisionShape2D:
				if child.get_meta("direction", 0.0) == direction:
					child.disabled = false
				else:
					child.disabled = true
		new_body.position = location
		add_child(new_body)
