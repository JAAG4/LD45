extends Label

onready var PlayerControl = get_node("/root/Base").find_node("PlayerControl")
onready var PlayerCharacter = PlayerControl.find_node("Player")
"""^^^ this line makes so the game has to have a "Node" as the 'Base node' of the scene """
var LHealth :int
var baseText := "Player's Health:"

func _process(delta):
	if PlayerCharacter is KinematicBody2D and PlayerCharacter.name=="Player":
		self.text = baseText + str(PlayerCharacter.Health)

#func _ready():
#	text = baseText + str(PlayerControl.PlayerHealthOverride) + "/" + str(PlayerControl.PlayerMaxHealth)
##	print(str(PlayerControl.name))
#	PlayerCharacter.connect("healthChanged",self,"_on_health_changed")
#	LHealth = PlayerCharacter.Health
#
#func _on_health_changed(value:int):
##	print("Label_foundHealth")
#	LHealth += value
#	if LHealth >=0:
#		text = baseText + str(LHealth) + "/" + str(PlayerControl.PlayerMaxHealth)
