extends CharacterBody2D

enum {DEFAULT, BOB, MESSY, CURLY, PONY, BALD}

const SPEED := 100.0
const ACCELERATION := 0.3 # out of 0.0 to 1.0
const CLIMB_SPEED := 50.0
const JUMP_VELOCITY := -300.0
const MAX_FALL_SPEED := 500.0
const MAX_COYOTE_TIME := 0.2
const JUMP_INPUT_BUFFERING := 0.2
const IDLE_SPEED_SQUARED := 100.0
const FLIP_SPEED := 1.0
const MIN_SPEED := 80

@onready var character_area := $CharacterArea
@onready var state_machine : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/StateMachine/playback")
@onready var sprite := $Sprite

@export var can_jump: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var climbing := false
var peaked := false
var bottomed := false
var coyote_time := 0.0
var jumped := false
var last_jump_press := 1.0
var lockout := 0.0
var stored_speed := 0.0
var dying := false
var sprite_type := randi_range(DEFAULT, BALD)
var stored_fall := 0.0
var is_fat := true


func _ready() -> void:
	GlobalNodeReferences.character = self
	for hair in $Sprite/Offset/Body/Head.get_children():
		if str(sprite_type) in hair.name:
			hair.visible = true
		else:
			hair.visible = false

func _physics_process(delta: float) -> void:
	# TEMP <- debug kill button
	if Input.is_action_just_pressed("debug_kill"):
		kill()
	
	
	
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
				peaked = false
				bottomed = false
				break
			else:
				climbing = false
		if overlapping_areas.is_empty():
			if climbing and not peaked and not bottomed:
				if Input.is_action_pressed("up"):
					peaked = true
				elif Input.is_action_pressed("down"):
					bottomed = true
	else:
		peaked = false
		bottomed = false
	
	# Climb or add gravity
	if climbing:
		if Input.is_action_pressed("up") and not peaked:
			velocity.y = -CLIMB_SPEED
		elif Input.is_action_pressed("down") and not bottomed:
			velocity.y = CLIMB_SPEED
		else:
			velocity.y = 0.0
	elif not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, MAX_FALL_SPEED)

	# Handle jump.
	if can_jump:
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
	
	# Shove & destroy blocks
	if lockout > 0.0:
		if lockout - delta >= 0.0:
			lockout -= delta
		else:
			lockout = 0.0
		
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if c.get_collider() is CharacterBody2D and c.get_collider().is_in_group("pushable") and lockout == 0.0:
			lockout += .1
			if (position.x + get_node("CollisionShape2D").shape.radius 
					+ (c.get_collider().get_node("CollisionShape2D").shape.size.x / 2) 
					< c.get_collider().position.x):
				c.get_collider().velocity.x = max(stored_speed, MIN_SPEED)
			elif (position.x - (get_node("CollisionShape2D").shape.radius 
					+ (c.get_collider().get_node("CollisionShape2D").shape.size.x / 2)) 
					> c.get_collider().position.x):
				c.get_collider().velocity.x = min(stored_speed, -MIN_SPEED)
		if c.get_collider() is StaticBody2D and c.get_collider().is_in_group("breakable") and stored_fall > 1.0 and is_fat:
			c.get_collider().queue_free()
		if c.get_collider() is StaticBody2D and c.get_collider().is_in_group("dropdown") and Input.is_action_pressed("down"):
			#c.get_collider().area.set_deferred("monitoring", true)
			position.y += 1
				
	stored_speed = velocity.x
	stored_fall = velocity.y
	
	# Animate based on motion
	if velocity.x > FLIP_SPEED:
		sprite.scale.x = abs(sprite.scale.x)
	elif velocity.x < -FLIP_SPEED:
		sprite.scale.x = -abs(sprite.scale.x)
	
	if not is_on_floor() and not climbing:
		state_machine.travel("jump")
	elif climbing:
		if velocity.length_squared() > IDLE_SPEED_SQUARED:
			state_machine.travel("climb")
		else:
			state_machine.travel("hold")
	elif velocity.length_squared() < IDLE_SPEED_SQUARED:
		state_machine.travel("idle")
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.travel("run")


func kill() -> void:
	if not dying:
		dying = true
		HunterSignalling.end_hunt.emit()
		# Code to save the body position when you die
		if not Progress.bodies.has(owner.get_meta("level")):
			Progress.bodies[owner.get_meta("level")] = {position: {"direction": sign(sprite.scale.x), 
					"type": sprite_type}}
		else:
			Progress.bodies[owner.get_meta("level")][position] = {"direction": sign(sprite.scale.x), 
					"type": sprite_type}
		
		var reloaded_scene : Node2D = load("uid://b0kxtk2p027ml").instantiate()
		GlobalNodeReferences.main.call_deferred("add_child", reloaded_scene)
		owner.queue_free()
