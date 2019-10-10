extends Control

onready var HSLabel :=$VBoxContainer/HighScoreLabel
onready var SLabel :=$VBoxContainer/ScoreLabel

var HSText:="High Score:"
var SText:="Score:"

func _ready():
	init_labels()
#	self.rect_size.x = OS.window_size.x
	self.rect_position.x = 300
	ScoreSingleton.connect("HighScore_Changed",self,"_on_highScore_changed")
	ScoreSingleton.connect("score_changed",self,"_on_score_changed")

func _on_highScore_changed(value:int):
	HSLabel.text = HSText + str(value)


func _on_score_changed(value:int):
	SLabel.text = SText + str(value)

func init_labels():
	ScoreSingleton.score = 0
	HSLabel.text = HSText + str(ScoreSingleton.highScore)
	SLabel.text = SText + str(ScoreSingleton.score)