extends Node2D

onready var lookt:= $LookAroundTimer
onready var shootT:= $ShootTimer
onready var pursueT:= $PursueTimer
onready var character:= $EnemyChar
onready var rayPivot:=$EnemyChar/RayPivot
onready var ray:=$EnemyChar/RayPivot/RayCast2D
onready var tweener :=$Tween

export var patrolInterval:float=2.5
export var bulletDamage:int=10
export var pursueTime:float=3
export var defaultLookDir:=Vector2.RIGHT
var pursueDir:Vector2
var canShoot:=false
var canPursue:=false
func _ready():

	character.Ammo=99999
	character.rotate_ray_manual_direction(defaultLookDir)
	ray.add_exception(character)
	randomize()
	lookt.wait_time = patrolInterval
	lookt.start()
	shootT.start()


func _process(delta):
	pursue()
	if canPursue:
		pursueDir = pursueDir.normalized()
		character.move(pursueDir)


func patrol_rotate():
	if canPursue:
		return
	var duration:float=1
	var amount:float= rand_range(-120,120)
	tweener.interpolate_property(rayPivot,"rotation_degrees",rayPivot.rotation_degrees,rayPivot.rotation_degrees+amount,duration,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tweener.start()


func _on_LookAroundTimer_timeout():
	patrol_rotate()


func pursue():
	var shotDirection:Vector2
	if ray.is_colliding() and (ray.get_collider() != null):
		var collider:Node2D=ray.get_collider()

		if collider.name == "Player" and canShoot:
			canPursue = true
			pursueT.start()
#			shotDirection=self.global_position-collider.global_position
			shotDirection= Vector2(cos(character.get_angle_to(collider.global_position)),sin(character.get_angle_to(collider.global_position)))
			shotDirection *=-1
			pursueDir = Vector2(cos(character.get_angle_to(collider.global_position)),sin(character.get_angle_to(collider.global_position)))

			character.shoot(shotDirection , bulletDamage)
			canShoot = false


func _on_ShootTimer_timeout():
	canShoot = true


func _on_PursueTimer_timeout():
	canPursue = false
