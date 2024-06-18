extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION := 0.3
var selected := false
var left_side := false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if selected == true:
		if left_side and GlobalNodeReferences.character.velocity.x < 0:
			velocity.x = GlobalNodeReferences.character.velocity.x
		if !left_side and GlobalNodeReferences.character.velocity.x > 0:
			velocity.x = GlobalNodeReferences.character.velocity.x
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	
func _on_interact() -> void:
	if GlobalNodeReferences.character.is_on_floor():
		selected = !selected
		if selected:
			interaction_area.action_name = "Deselect"
			if GlobalNodeReferences.character.position.x < position.x:
				left_side = true
			else:
				left_side = false
		else:
			interaction_area.action_name = "Select"
		GlobalNodeReferences.character.can_jump = !GlobalNodeReferences.character.can_jump
	
