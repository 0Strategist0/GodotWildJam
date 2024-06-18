extends CharacterBody2D


const SPEED = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = velocity.x
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
