extends Node

enum {DEFAULT, BOB, MESSY, CURLY, BALD, PONY}

var fat := true
var fast := true
var strong := true
var small := true
var hair := DEFAULT

func randomize_hair() -> void:
	hair = (hair + randi_range(1, 5)) % 6
