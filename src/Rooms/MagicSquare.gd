extends Area2D

signal dungeon_regen

onready var sprite:=$AnimatedSprite
onready var anim := $AnimationPlayer
export var scoreValue:int=65

func _ready():

	sprite.play("default")
	anim.play("glow")
	connect("dungeon_regen",ScoreSingleton,"_on_MagicSquare_dungeon_regen")


func _on_MagicSquare_body_entered(body):
	var bodyGroups = body.get_groups()
	for i in bodyGroups.size():
		if bodyGroups[i] == "Player":
			print("Name:"+str(body.name))
			emit_signal("dungeon_regen")
			ScoreSingleton.Add_to_score(scoreValue)
			self.get_parent().queue_free()
