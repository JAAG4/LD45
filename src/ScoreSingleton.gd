extends Node

signal score_changed(newValue)
signal HighScore_Changed(newValue)
signal generate_again
var highScore:int=0
var score:int=0

func _ready():
	score=0
#	connect(Sc)

func Add_to_score(value:int):
	score += value
	emit_signal("score_changed",score)
	if score >= highScore:
		highScore = score
		emit_signal("HighScore_Changed",highScore)

func _on_MagicSquare_dungeon_regen():
	emit_signal("generate_again")