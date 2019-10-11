extends KinematicBody2D

onready var timer:=$Timer

signal hit(damage)
signal healthChanged(deltaValue)
signal died

export var speed:int=100
export var damage:int=15
export var Health :int = 30
export var scoreValue:int=55

var direction :=Vector2.ZERO
var _velocity :=Vector2.ZERO
var canWalk:=true


func _ready():
	timer.start()
	calc_random_direction()
	connect( "hit", self, "_on_hit")
	connect("died", self, "_on_death")
	randomize()


func _process(delta):
	if canWalk:
		move_and_slide(_velocity)
	else: move_and_slide(Vector2.ZERO)


func calc_random_direction():
	direction = Vector2(rand_range(-2,2),rand_range(-2,2)).normalized()
#	print("d:"+str(direction))
	_velocity = direction * speed


func flipbool(val:bool)->bool:
	if val: return false
	else: return true


func _on_Timer_timeout():
	canWalk = flipbool(canWalk)
	calc_random_direction()
#	print("t/o--canw:"+str(canWalk))
	timer.start()


func _on_Area2D_body_entered(body):
	var bodyGroups = body.get_groups()
	var selfGroups = self.get_groups()
	for i in bodyGroups.size():
		if bodyGroups[i] != selfGroups[i]:
			print(str(self.name)+ "hit " + str(body.name)+"for "+str(self.damage)+" damage!")
			body.emit_signal("hit",damage)


func _on_hit(damage):
#	print(str(self.name)+":"+"Dmgd:"+str(damage))
#	print(str(self.name)+"HCH:"+str(Health)+">>"+str(Health-1 * damage))
	Health-=1 * damage
	if Health <=0:
		emit_signal("died")


func _on_death():
	print(str(self.name)+" died!")
	self.queue_free()
	ScoreSingleton.Add_to_score(scoreValue)