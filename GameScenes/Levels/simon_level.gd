extends Node2D

const DEAD_CHARACTER_SCENE := preload("uid://caicj44ceb3on")

var puzzle_length = 5
var puzzle = []
var current = []
var solved = false
@onready var Lights : Array[PointLight2D] = []

var timer := Timer.new()

func _ready() -> void:
	for i in range(9):
		var num = i + 1
		Lights.append(get_node("Switches/LeverSwitch" + str(num) + "/PointLight2D"))
	
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

func load_puzzle():
	if puzzle_length < 8:
		for num in current:
			Lights[num-1].enabled = false
		puzzle.clear()
		current.clear()
		await get_tree().create_timer(2).timeout
		var rng = RandomNumberGenerator.new()
		var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		for i in range(puzzle_length):
			var num = rng.randi_range(0, len(nums)-1)
			puzzle.append(nums[num])
			nums.remove_at(num)
		print(puzzle)
		show_puzzle()
	else:
		solved = true

func show_puzzle():
	get_tree().create_timer(1.0).timeout
	for num in puzzle:
		print(num)
		Lights[num-1].enabled = true
		await get_tree().create_timer(0.5).timeout
		Lights[num-1].enabled = false
		await get_tree().create_timer(0.5).timeout
	
func check_solution():
	for i in range(len(puzzle)):
		if puzzle[i] != current[i]:
			print("failed")
			await get_tree().create_timer(1.0).timeout
			for num in current:
				Lights[num-1].enabled = false
			await get_tree().create_timer(1.0).timeout
			current.clear()
			show_puzzle()
			return
	# flash lights if correct
	await get_tree().create_timer(0.5).timeout
	for num in current:
		Lights[num-1].enabled = false
	await get_tree().create_timer(0.5).timeout
	for num in current:
		Lights[num-1].enabled = true
	# create next puzzle
	puzzle_length += 1
	load_puzzle()

func _on_lever_switch_lever_toggled(number: int):
	current.append(number)
	print(current)
	if !solved:
		Lights[number-1].enabled = true
		if len(current) == len(puzzle):
			check_solution()


func _on_trigger_puzzle_body_entered(body):
	await get_tree().create_timer(2).timeout
	load_puzzle()
