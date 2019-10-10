extends Area2D

export var ammoCount:int = 10
export var scoreValue:int = 15
func _on_AmmoPickup_body_entered(body):
	var bodyGroups = body.get_groups()
	for i in bodyGroups.size():
		if bodyGroups[i] == "Player":
			print("NAme:"+str(body.name))
			body.emit_signal("foundAmmo",ammoCount)
			ScoreSingleton.Add_to_score(scoreValue)
			self.queue_free()