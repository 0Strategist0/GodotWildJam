extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION := 0.3
var selected = false
var left_side = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if selected == true:
		var direction := Input.get_axis("left", "right")
		if direction and ((left_side and direction < 0) or (!left_side and direction > 0)):
			velocity.x = lerp(velocity.x, direction * SPEED, 
					pow(ACCELERATION, 60.0 * delta))
		else:
			velocity.x = lerp(velocity.x, 0.0, pow(ACCELERATION, 60.0 * delta))	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact():
	if GlobalNodeReferences.character.position.x < position.x:
		left_side = true
	else:
		left_side = false
	selected = !selected
