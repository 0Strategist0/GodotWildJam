extends CharacterBody2D


const ACCELERATION = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = velocity.x
	else:
		velocity.x = lerp(velocity.x, 0.0, pow(ACCELERATION, 60.0 * delta))
	
	move_and_slide()
