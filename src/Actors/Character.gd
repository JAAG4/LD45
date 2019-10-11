extends KinematicBody2D

signal hit(damage)
signal healthChanged(deltaValue)
signal died
signal foundAmmo(AmmoCount)
signal shot
signal score_change(deltaValue)

export var max_speed := 100
export var Health :int = 40
export var Ammo :int = 0
export var scoreValue:int=50


onready var RayPivot := $RayPivot
onready var Raycast := $RayPivot/RayCast2D
onready var RaySprite := $Sprite
var BulletScene := preload("res://src/Bullet.tscn")


func _ready():
#	#print(self.name + ":" + str(self))
	connect( "hit", self, "_on_hit")
	connect("died", self, "_on_death")
	connect("foundAmmo", self, "_on_foundAmmo")
	connect("healthChanged",self,"_on_health_changed")
	emit_signal("foundAmmo",0)
	emit_signal("healthChanged",0)


func move(direction:Vector2):
	var velocity = Vector2.ZERO
	velocity += direction.normalized()
	velocity *= Vector2(max_speed,max_speed)
	move_and_slide(velocity, Vector2.ZERO)


func shoot(shootDir:=Vector2.RIGHT,damage:int=10):
	if self.Ammo <= 0:
		#print("No Ammo")
		return

#	var ShootingNode = get_parent().get_parent()
	var ShootingNode := get_node("/root/Base")
	var ShootPosition = self.global_position
	var newBullet := BulletScene.instance()
#	#print("ShootingNode:"+str(ShootingNode.name))
#	#print("global:"+str(self.global_position))
#	newBullet.position = ShootPosition
	newBullet.position = ShootPosition
	newBullet.direction = shootDir
	newBullet.damage = damage
	#print("shtNd:"+str(ShootingNode.name))
	#print("selfGlobalpos:"+str(self.global_position)+"Shootingpos:"+str(ShootPosition))
	#print("newbulletpos:"+str(newBullet.position)+"newBglob:"+str(newBullet.global_position))
	var selfgroups:Array = self.get_groups()
	for i in selfgroups.size():
		newBullet.add_to_group(selfgroups[i])
	ShootingNode.add_child(newBullet)
	emit_signal("shot")
	Ammo -=1


func rotate_ray_manual(rot:float):
	RayPivot.rotation = rot
func rotate_ray_manual_direction(direction:Vector2):
	$RayPivot.look_at(self.global_position + direction)


func _on_hit(damage:int=0):
	#print(str(self.name)+":"+"Dmg:"+str(damage))
	update_health(-1 * damage)



func update_health(deltaValue:int=0):
	Health += deltaValue
	emit_signal("healthChanged",deltaValue)
	#print(self.name+"HealthUpdate: delta<"+str(deltaValue)+">\t New Health="+str(Health))
	if Health <= 0:
		emit_signal("died")


func _on_death():
	#print(str(self.name)+" died!")
	get_parent().queue_free()

	if self.name != "Player":
		ScoreSingleton.Add_to_score(scoreValue)


func _on_foundAmmo(AmmoCount:int):
	self.Ammo += AmmoCount

