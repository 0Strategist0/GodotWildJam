extends Node2D

const DEAD_CHARACTER_SCENE := preload("uid://caicj44ceb3on")
@onready var TriggerPuzzle := $TriggerPuzzle/CollisionShape2D
@onready var fail_sound: AudioStream = preload("res://GameScenes/NPCs/adult_voice.wav")
@onready var success_sound: AudioStream = preload("res://GameScenes/Objects/Switches/plate_sfx.wav")
@onready var sound_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var door := $Door
@onready var door_hitbox := $Door/CollisionShape2D

var puzzle_length : int = 5
var puzzle := []
var current := []
var solved : bool = false
@onready var Levers := []

var timer := Timer.new()

func _ready() -> void:
	for i : int in range(9):
		var num : int = i + 1
		Levers.append(get_node("Levers/LeverSwitch" + str(num)))
	
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

func load_puzzle() -> void:
	# generate puzzle
	if puzzle_length < 8:
		puzzle.clear()
		current.clear()
		var rng := RandomNumberGenerator.new()
		var nums := [1, 2, 3, 4, 5, 6, 7, 8, 9]
		for i in range(puzzle_length):
			var num := rng.randi_range(0, len(nums)-1)
			puzzle.append(nums[num])
			nums.remove_at(num)
		#print(puzzle)
		show_puzzle()
	else:
		solved = true
		door.visible = false
		door_hitbox.disabled = true

func reset_switches() -> void:
	for lever in Levers:
		if lever.activated != false:
			lever.flip_lever(false)
			lever.activated = false
	
func show_puzzle() -> void:
	await get_tree().create_timer(2.0).timeout
	for num : int in puzzle:
		#print(num)
		Levers[num-1].flip_lever(true)
		await get_tree().create_timer(0.5).timeout
		Levers[num-1].flip_lever(false)
		await get_tree().create_timer(0.5).timeout
	# re-enable levers
	for lever in Levers:
		lever.enabled = true
	
func check_solution() -> void:
	for i : int in range(len(puzzle)):
		if puzzle[i] != current[i]:
			await get_tree().create_timer(1.0).timeout
			sound_player.stream = fail_sound
			sound_player.play()
			for num : int in current:
				Levers[num-1].flip_lever(false)
			reset_switches()
			current.clear()
			show_puzzle()
			return
	# flip all levers if correct
	sound_player.stream = success_sound
	await get_tree().create_timer(1.0).timeout
	sound_player.play()
	for lever in Levers:
		if lever.activated != true:
			lever.flip_lever(true)
			lever.activated = true
	await get_tree().create_timer(1.5).timeout
	reset_switches()
	# create next puzzle
	puzzle_length += 1
	load_puzzle()

func _on_lever_switch_lever_toggled(number: int) -> void:
	current.append(number)
	#print(current)
	if !solved:
		Levers[number-1].activated = true
		if len(current) == len(puzzle):
			for lever in Levers:
				lever.enabled = false
			check_solution()


func _on_trigger_puzzle_body_entered(body: Node2D) -> void:
	TriggerPuzzle.set_deferred("disabled", true)
	# disable levers
	for lever in Levers:
		lever.enabled = false
	load_puzzle()
