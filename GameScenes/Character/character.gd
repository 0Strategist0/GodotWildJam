extends CharacterBody2D

const SPEED := 100.0
const ACCELERATION := 0.3 # out of 0.0 to 1.0
const CLIMB_SPEED := 50.0
const JUMP_VELOCITY := -300.0
const MAX_FALL_SPEED := 500.0
const MAX_COYOTE_TIME := 0.2
const JUMP_INPUT_BUFFERING := 0.2
const push_force = 100.0

@onready var character_area := $CharacterArea

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var climbing := false
var coyote_time := 0.0
var jumped := false
var last_jump_press := 1.0

func _ready() -> void:
	GlobalNodeReferences.character = self

func _physics_process(delta: float) -> void:
	# Don't let the player move if they're talking to someone - FIX LATER
	if DialogManager.is_dialog_active:
		return
	
	
	# Check if you are climbing
	if (Input.is_action_pressed("up") 
			or Input.is_action_pressed("down")
			or climbing):
		var overlapping_areas : Array = character_area.get_overlapping_areas()
		for area: Area2D in overlapping_areas:
			if area.is_in_group("climbable"):
				climbing = true
				break
			else:
				climbing = false
		if overlapping_areas.is_empty():
			climbing = false
	
	# Climb or add gravity
	if climbing:
		if Input.is_action_pressed("up"):
			velocity.y = -CLIMB_SPEED
		elif Input.is_action_pressed("down"):
			velocity.y = CLIMB_SPEED
		else:
			velocity.y = 0.0
	elif not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, MAX_FALL_SPEED)

	# Handle jump.
	if climbing or is_on_floor():
		coyote_time = 0.0
		jumped = false
	else: 
		coyote_time += delta
	
	if Input.is_action_just_pressed("jump"):
		last_jump_press = 0.0
	else:
		last_jump_press += delta
	
	if (last_jump_press <= JUMP_INPUT_BUFFERING
			and coyote_time <= MAX_COYOTE_TIME
			and not jumped):
		velocity.y = JUMP_VELOCITY
		climbing = false
		jumped = true

	# Get the input direction and handle the movement/deceleration.
	if not climbing:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = lerp(velocity.x, direction * SPEED, 
					pow(ACCELERATION, 60.0 * delta))
		else:
			velocity.x = lerp(velocity.x, 0.0, pow(ACCELERATION, 60.0 * delta))
	else:
		velocity.x = 0.0

	move_and_slide()

	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is CharacterBody2D and c.get_collider().is_in_group("pushable"):
			if (position.x + get_node("CollisionShape2D").shape.radius + 
					(c.get_collider().get_node("CollisionShape2D").shape.size.x / 2) 
					< c.get_collider().position.x):
				c.get_collider().velocity.x += 500
			elif (position.x - (get_node("CollisionShape2D").shape.radius 
					+ (c.get_collider().get_node("CollisionShape2D").shape.size.x / 2)) 
					> c.get_collider().position.x):
				c.get_collider().velocity.x -= 500


func kill() -> void:
	print("Oof ouch my bones (character died)")
