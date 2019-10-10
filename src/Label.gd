extends Label

onready var PlayerCharacter = get_node("/root/Base").find_node("Player")
"""^^^ this line makes so the game has to have a "Node" as the 'Base node' of the scene """
var LAmmo :int
#onready var test.find
var baseText := "Player's Ammo:"
func _ready():
	print("PlayerCharacter:"+str(PlayerCharacter))
	text = baseText + str(0)
#	print(str(PlayerCharacter.name))
	PlayerCharacter.connect("foundAmmo",self,"_on_foundAmmo")
	PlayerCharacter.connect("shot",self,"_on_shot")
	LAmmo = PlayerCharacter.Ammo

func _on_foundAmmo(AmmoCount:int):
#	print("Label_foundammo")
	LAmmo += AmmoCount
	text = baseText + str(LAmmo)

func _on_shot():
	if LAmmo > 0:
		LAmmo -= 1
		text = baseText + str(LAmmo)