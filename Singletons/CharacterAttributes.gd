extends Node

enum {DEFAULT, BOB, MESSY, CURLY, PONY, BALD}

var fat := false
var fast := false
var strong := false
var small := true
var hair := DEFAULT

func randomize_attributes() -> void:
	var code := randi_range(1, 4)
	
	fat = code == 1
	fast = code == 2
	strong = code == 3
	small = code == 4
	
	hair = (hair + randi_range(1, 5)) % 5
