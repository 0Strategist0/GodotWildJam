extends Node

enum {DEFAULT, BOB, MESSY, CURLY, BALD, PONY}

var fat := false
var fast := false
var strong := false
var small := false
var hair := DEFAULT

func randomize_hair() -> void:
	hair = (hair + randi_range(1, 5)) % 6
