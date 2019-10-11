extends Node2D

onready var Turret := $Turret
onready var Timer := $Timer
onready var Ray := $Turret/RayPivot/RayCast2D
enum ShootType {TIMED,ON_SIGHT}

export (ShootType) var TurretType = 0
export var ShotDirection:=Vector2.LEFT
export var BulletDamage :int= 10
export var Cooldown:float = .75

var canShoot := false

func _ready():
	Ray.add_exception(Turret)
	Turret.Ammo = 99999
	Turret.rotate_ray_manual_direction(ShotDirection)

#	if TurretType is ShootType.TIMED:
	Timer.start(Cooldown)
	Timer.connect("timeout",self,"_on_Timer_timeout")


func _process(delta) -> void :
	if TurretType == ShootType.TIMED:
		return

	if TurretType == ShootType.ON_SIGHT and Ray.is_colliding() and canShoot:
		print("TurretRaycollw/:"+str(Ray.get_collider()))
		Turret.shoot(ShotDirection * -1 , BulletDamage)
		canShoot = false


func _on_Timer_timeout():
	if TurretType == ShootType.TIMED:
		Turret.shoot(ShotDirection * -1 , BulletDamage)
	else:
		canShoot = true