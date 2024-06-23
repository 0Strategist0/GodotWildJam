extends CharacterBody2D

enum {DEFAULT, BOB, MESSY, CURLY, BALD, PONY}
const ACCELERATION := 0.3 # out of 0.0 to 1.0
const JUMP_VELOCITY := -300.0
const MAX_FALL_SPEED := 500.0
const MAX_COYOTE_TIME := 0.2
const JUMP_INPUT_BUFFERING := 0.2
const IDLE_SPEED_SQUARED := 100.0
const FLIP_SPEED := 1.0
const MIN_SPEED := 80
const PROBABLY_SOFTLOCKED_TIME := 5.0

const FAST_SPEED_MULTIPLE := 1.5
const SMALL_SIZE_MULTIPLE := 0.7
const FAT_SPEED_MULTIPLE := 0.75
const HARD_FALL_SCALE := 300.0
const HARD_FALL_TIME := 0.2

@onready var character_area := $CharacterArea
@onready var state_machine : AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/StateMachine/playback")
@onready var sprite := $Sprite
@onready var camera := $Camera2D

@export var can_jump: bool = true
@export var getting_up := false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed := 100.0
var climb_speed := 50.0
var climbing_object : Area2D
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
var is_fat := false
var is_strong := false


func _ready() -> void:
	GlobalNodeReferences.character = self
	
	# Initialize with attributes
	print("fat: ", CharacterAttributes.fat)
	print("fast: ", CharacterAttributes.fast)
	print("strong: ", CharacterAttributes.strong)
	print("small: ", CharacterAttributes.small)
	# Fatness
	is_fat = CharacterAttributes.fat
	if CharacterAttributes.fat:
		speed *= FAT_SPEED_MULTIPLE
		climb_speed *= FAT_SPEED_MULTIPLE
	for fat in $Sprite/Offset/Body.find_children("*Fat*"):
		fat.visible = is_fat
	# Speediness
	if CharacterAttributes.fast:
		speed *= FAST_SPEED_MULTIPLE
		climb_speed *= FAST_SPEED_MULTIPLE
	# Strength
	is_strong = CharacterAttributes.strong
	# Smallness
	if CharacterAttributes.small:
		sprite.scale *= SMALL_SIZE_MULTIPLE
		$CollisionShape2D.shape.radius *= SMALL_SIZE_MULTIPLE
		$CollisionShape2D.shape.height *= SMALL_SIZE_MULTIPLE
		for collision in [$CollisionShape2D, $CharacterArea/CollisionShape2D]:
			collision.position.y += (1.0 - SMALL_SIZE_MULTIPLE) * 4.5
	# Hair
	sprite_type = CharacterAttributes.hair
	for hair in $Sprite/Offset/Body/Head.get_children():
		if str(sprite_type) in hair.name:
			hair.visible = true
		else:
			hair.visible = false
	
	
	# Fade in
	$TransitionAnimations.play("Life")
	if owner.get_meta("level") == "b1":
		getting_up = true
		state_machine.travel("GetUp")

func _physics_process(delta: float) -> void:
	# TEMP <- debug kill button
	if Input.is_action_just_pressed("debug_kill"):
		kill()
	
	if getting_up:
		return
	
	# Check if you are climbing
	if (Input.is_action_pressed("up") 
			or Input.is_action_pressed("down")
			or climbing):
		var overlapping_areas : Array = character_area.get_overlapping_areas()
		for area: Area2D in overlapping_areas:
			if area.is_in_group("climbable"):
				climbing_object = area
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
	if climbing and not DialogManager.is_dialog_active:
		if Input.is_action_pressed("up") and not peaked:
			velocity.y = -climb_speed
		elif Input.is_action_pressed("down") and not bottomed:
			velocity.y = climb_speed
		else:
			velocity.y = 0.0
	elif not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, MAX_FALL_SPEED)

	# Handle jump.
	if can_jump and not DialogManager.is_dialog_active:
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
				and (coyote_time <= MAX_COYOTE_TIME
					and not jumped)
				or coyote_time > PROBABLY_SOFTLOCKED_TIME):
			velocity.y = JUMP_VELOCITY
			climbing = false
			jumped = true
	
	# Get the input direction and handle the movement/deceleration.
	if not climbing and not DialogManager.is_dialog_active:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = lerp(velocity.x, direction * speed, 
					pow(ACCELERATION, 60.0 * delta))
		else:
			velocity.x = lerp(velocity.x, 0.0, pow(ACCELERATION, 60.0 * delta))
	else:
		velocity.x = 0.0
	
	# TEMP DEV HAX
	if Input.is_action_pressed("devhax"):
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = lerp(velocity.x, direction * speed * 4.0, 
					pow(ACCELERATION, 60.0 * delta))
		else:
			velocity.x = lerp(velocity.x, 0.0, pow(ACCELERATION, 60.0 * delta))
	
	#var pre_move_velocity = velocity.y
	move_and_slide()
	#if is_fat and is_on_floor() and pre_move_velocity > 0.0:
		#camera.shake(pow(pre_move_velocity / HARD_FALL_SCALE, 3.0), HARD_FALL_TIME)
	
	# Shove & destroy blocks
	if lockout > 0.0:
		if lockout - delta >= 0.0:
			lockout -= delta
		else:
			lockout = 0.0
		
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		if (c.get_collider() is CharacterBody2D 
				and (c.get_collider().is_in_group("pushable") 
				or (c.get_collider().is_in_group("heavy") and is_strong)) 
				and lockout == 0.0):
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
			c.get_collider().visible = false
			c.get_collider().get_node("CollisionShape2D").disabled = true
		if c.get_collider() is StaticBody2D and c.get_collider().is_in_group("dropdown") and Input.is_action_pressed("down"):
			#c.get_collider().area.set_deferred("monitoring", true)
			position.y += 1
				
	stored_speed = velocity.x
	stored_fall = velocity.y
	
	# Animate based on motion
	if climbing:
		sprite.scale.x = sign(climbing_object.global_position.x - global_position.x) * abs(sprite.scale.x)
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
					"type": sprite_type, "size": SMALL_SIZE_MULTIPLE if CharacterAttributes.small else 1.0,
					"fat": is_fat}}
		else:
			Progress.bodies[owner.get_meta("level")][position] = {"direction": sign(sprite.scale.x), 
					"type": sprite_type, "size": SMALL_SIZE_MULTIPLE if CharacterAttributes.small else 1.0,
					"fat": is_fat}
		
		$TransitionAnimations.play("Death")


func _on_death_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death":
		var reloaded_scene : Control = load("uid://i7s5tj205axq").instantiate()
		GlobalNodeReferences.main.call_deferred("add_child", reloaded_scene)
		owner.queue_free()
