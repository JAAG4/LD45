extends Area2D

export var HealCount:int = 5
export var scoreValue:int=25

func _on_HealthPickup_body_entered(body):
	var bodyGroups = body.get_groups()
	for i in bodyGroups.size():
		if bodyGroups[i] == "Player":
			print("Name Healed:"+str(body.name))
			body.emit_signal("healthChanged",+HealCount)
			if body.has_method("update_health"):
				body.call("update_health",HealCount)
			ScoreSingleton.Add_to_score(scoreValue)
			self.queue_free()