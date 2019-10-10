extends KinematicBody2D

var damage := 5
var velocity := Vector2.ZERO
var direction := Vector2.RIGHT
var speed := 32 * 10


func _process(delta):
	velocity = speed * direction.normalized() * -1
	move_and_slide(velocity)


func _on_Area2D_body_entered(body):
	var bodyGroups = body.get_groups()
	var selfGroups = self.get_groups()
	for i in bodyGroups.size():
		if bodyGroups[i] == "Enviroment":
			queue_free()
		for j in selfGroups.size():
			if bodyGroups[i]!="Enemy" and bodyGroups[i]!="Player":
				continue
			if selfGroups[j]!="Enemy" and selfGroups[j]!="Player":
				continue

#				 and selfGroups[j]!=("Enemy" or "Player"): continue
			if bodyGroups[i] != selfGroups[j]:
				print(str(self.name)+ "hit " + str(body.name))
				body.emit_signal("hit",damage)

