extends AnimationPlayer




func _on_throw_off_cutscene_body_entered(body: Node2D) -> void:
	if body == GlobalNodeReferences.character:
		$"../VillageNPCs/NPC10/AnimationTree".active = false
		$"../Character/AnimationTree".active = false
		play("YeetChild")
