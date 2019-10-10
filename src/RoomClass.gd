extends Node2D
class_name RoomClass
"""
Class would be a parent of a 'room scene' (Made with a Tileset or something)

The purpose of this class is to know how to connect properly the rooms
when creating a dungeon

"""

export var ConnectsUp:bool
export var ConnectsDown:bool
export var ConnectsLeft:bool
export var ConnectsRight:bool

func _ready():
	$TileMap.add_to_group("Enviroment")

func connect_Arr()->Array:
	var arr:Array = []
	arr.append(ConnectsUp)
	arr.append(ConnectsDown)
	arr.append(ConnectsLeft)
	arr.append(ConnectsRight)
	return arr


func check_n_sides_conn(connectArray:Array=self.connect_Arr())->int:
	var nSides:int=0

	for i in connectArray.size():
		if connectArray[i] == true:
			nSides+=1
	return nSides


func check_sides(side:String)->bool:
	match(side):
		"Up": return ConnectsUp
		"Down": return ConnectsDown
		"Left": return ConnectsLeft
		"Right": return ConnectsRight
		"Verticals": return (ConnectsUp and ConnectsDown)
		"Horizontals": return (ConnectsLeft and ConnectsRight)
		"All": return (ConnectsUp and ConnectsDown and ConnectsLeft and ConnectsRight)
		"LU": return (ConnectsLeft and ConnectsUp)
		"LD": return (ConnectsLeft and ConnectsDown)
		"RU": return (ConnectsRight and ConnectsUp)
		"RD": return (ConnectsRight and ConnectsDown)