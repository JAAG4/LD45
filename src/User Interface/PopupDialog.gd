extends PopupDialog

onready var PlayerCharacter = get_node("/root/Base").find_node("Player")
"""^^^ this line makes so the game has to have a "Node" as the 'Base node' of the scene """

func _ready():
	PlayerCharacter.connect("died",self,"_on_Player_died")

func _on_Player_died():
	popup_centered()
