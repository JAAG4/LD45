extends Node2D

onready var PlayerCharacter := $Player
onready var RaycastPivot := $Player/RayPivot
onready var CooldownTimer:= $Player/Cooldown
var _direction := Vector2.ZERO

export var bulletDamage:int = 10
export var PlayerHealthOverride:= 0
export var PlayerMaxHealth := 50

var score:int=0

func _ready():
	PlayerCharacter.Health = PlayerHealthOverride
#	PlayerCharacter.connect("healthChanged",self,"_on_health_changed")
	print("HealthOverride:"+str(PlayerHealthOverride)+"PLayerHealth:"+str(PlayerCharacter.Health))


#func _on_health_changed():
#	if PlayerCharacter.Health > PlayerMaxHealth:
#			var correct:int = PlayerCharacter.Health - PlayerMaxHealth
#			PlayerCharacter.emit_signal("healthChanged",-correct)
#			PlayerCharacter.Health = PlayerMaxHealth


func rotate_raycast_to_mouse() -> void:
	RaycastPivot.look_at(get_global_mouse_position())


func _player_direction() -> Vector2:
	_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return _direction


func _process(delta) -> void:
	if PlayerCharacter.Health < 0: return

	rotate_raycast_to_mouse()
	PlayerCharacter.move( _player_direction() )

	#Shooting Behaviour
	if Input.is_action_pressed("Shoot") and CooldownTimer.is_stopped():
		ShootBullet()


func ShootBullet() -> void:
	CooldownTimer.start()
	var group := "null"
	group = self.get_groups()[0]

	var shootdirection := Vector2()
	shootdirection = PlayerCharacter.position - get_local_mouse_position()

	PlayerCharacter.shoot(shootdirection,bulletDamage)


func plus_bullet_damage(value:int=0):
	bulletDamage+=value


func minus_bullet_damage(value:int=0):
	bulletDamage-=value


