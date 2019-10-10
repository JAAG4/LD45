extends Node2D

const ROOM_SIZE := 12 # Actually is From 0 to 9 but this size avoids closed spaces that may trap the player

signal StartedGen
signal StartedGenBorder
signal FinishedGenBorder
signal StartedGenInner
signal FinishedGenInner
signal FinishedGen

onready var TileMap:=$BorderTileMap
onready var TileSize:int=TileMap.cell_size
onready var roomHolder:=$RoomHolder
enum RoomTypes {EMPTY,ENEMY_ITEMS,ITEMS,ENEMY}

export var LevelSize:=Vector2(9,9)
export var Margin :int= 2

export var probEmpty:float=1
export var probEnemyItem:float=1
export var probItem:float=1
#export var probEnemy:float=1
var probTotal:float

var BorderSize:Vector2= LevelSize * ROOM_SIZE

var defaultRoomPack:PackedScene=preload("res://src/Rooms/Empty/RoomClass_Empty_Empty.tscn")
var specialRoomPack:PackedScene= preload("res://src/Rooms/RoomClass_Special_Cross1.tscn")

var EmptyRooms:Array = [
preload("res://src/Rooms/Empty/RoomClass_Empty_Empty.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Corridor_Horizontal.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Corridor_Horizontal_Split.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Corridor_Horizontal_Split2.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Corridor_Vertical_Split.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Corridor_Vertical_Split2.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Cross_1.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Cross_2.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Corner_LU.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Corner_RU.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Diag_LU.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Diag_RU.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Top.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Corridor_Vertical.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Corners.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_XShape.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Vert_Thin.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Cross_Thin.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_CShape.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_UShape.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_CShape2.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_nShape.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_4SidesBits.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Corner_LD.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Corner_RD.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Center_Diamond.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_Center_Square.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_IShape.tscn"),
preload("res://src/Rooms/Empty/RoomClass_Empty_Wall_EShape.tscn"),
]

var EnemyItemRooms:Array = [
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItems_4SidesBits_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItems_4SidesBits_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItems_Corners.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Horizontal.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Horizontal_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Horizontal_3.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Horizontal_Split2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Horizontal_Split_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Horizontal_Split_1_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Horizontal_Split_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Vertical_Split2_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Vertical_Split_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Corridor_Vertical_Split_3.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Cross_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Cross_1_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Cross_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Cross_2_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Empty.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Empty_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Empty_3.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Empty_4.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Center_Diamond.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Center_Square.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Center_Square_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Center_Square_2_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_LD.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_LD_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_LD_2_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_LU_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_LU_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_RD_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_RU_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Corner_RU_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Cross_Thin_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Cross_Thin_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_CShape2_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_CShape2_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_CShape.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Diag_LU_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Diag_LU_2_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_EShape_1.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_EShape_2.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_IShape.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_nShape.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_Top.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_Wall_UShape.tscn"),
preload("res://src/Rooms/Enemies&Items/RoomClass_EnemyItem_XShape_2.tscn")
]

var ItemRooms:Array = [
preload("res://src/Rooms/Items/RoomClass_Items_4SidesBits.tscn"),
preload("res://src/Rooms/Items/RoomClass_Items_Corners.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Horizontal.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Horizontal_Split2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Horizontal_Split_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Horizontal_Split_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Horizontal_Split_3.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Vertical_Split_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Vertical_Split2_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Vertical_Split_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Corridor_Vertical_Split_3.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Cross_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Cross_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Empty.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Empty_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Center_Diamond.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Center_Diamond_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Center_Square.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Center_Square_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Corner_LD.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Corner_LD_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Corner_LU_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Corner_LU_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Corner_RD_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Corner_RU.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Cross_Thin_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Cross_Thin_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_CShape2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_CShape.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Diag_LU_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Diag_LU_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_EShape.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_EShape_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_IShape.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_nShape.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_nShape_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Top.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Top_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_UShape.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_UShape_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Vert_Thin_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_Wall_Vert_Thin_2.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_XShape_1.tscn"),
preload("res://src/Rooms/Items/RoomClass_Item_XShape_2.tscn")
]

#var EnemyRooms:Array = []

var Rooms =[]


func _ready():
#	randomize()
	fixprob()
	Rooms = create_2d_Array()
	populate_dungeon1()
	ScoreSingleton.connect("generate_again",self,"_on_Singleton_generate_again")



func create_2d_Array() -> Array:
	var array = []
	for i in LevelSize.x:
		array.append([])
		for j in LevelSize.y:
			array[i].append(null)

	return array;

func populate_dungeon1():
	randomize()
	emit_signal("StartedGen")
	gen_special_room()
	gen_dungeon_borders()
	gen_dungeon_inner_1()
	emit_signal("FinishedGen")


func gen_dungeon_borders():
	emit_signal("StartedGenBorder")

	#Horizontal Border
	for i in range(-Margin,BorderSize.x+Margin):
		TileMap.set_cell(i , -Margin , 0)
		TileMap.set_cell(i , BorderSize.y+Margin , 0)

	#Vertical Border
	for j in range(-Margin,BorderSize.y+Margin):
		TileMap.set_cell(-Margin , j , 0)
		TileMap.set_cell(BorderSize.x+Margin , j , 0)

	emit_signal("FinishedGenBorder")


func gen_dungeon_inner_1():

	emit_signal("StartedGenInner")

	var newRoomPack:PackedScene
	Rooms[0][0]= defaultRoomPack.instance()

	var Coordinates:Vector2
	print("Rooms:\n")
	print(Rooms)
	for i in range(0 , LevelSize.x):
		for j in range(0 , LevelSize.y):


			if Rooms[i][j] != null:
				print("Didn't fill"+str(Vector2(i,j))+str(Vector2(i,j)*ROOM_SIZE*TileSize)+"Wasn't Empty" )
				continue

			Coordinates = Vector2(i,j)
			Coordinates *= ROOM_SIZE
			Coordinates *= TileSize

#			probTotal = probEmpty + probItem + probEnemyItem
			var rng:float = rand_range(0,probTotal)
			print(Vector2(i,j))
			if rng <= probEmpty:
				print("pEmpty"+str(Coordinates))
				newRoomPack = EmptyRooms[floor(rand_range(0,EmptyRooms.size()))]

			elif rng > probEmpty and rng <= probItem:
				print("pItem"+str(Coordinates))
				newRoomPack = ItemRooms[floor(rand_range(0,ItemRooms.size()))]

			elif rng > probItem and rng <= probTotal:
				print("pEnemy"+str(Coordinates))
				newRoomPack = EnemyItemRooms[floor(rand_range(0,EnemyItemRooms.size()))]
#			else: #dirty fix :(
#				print("pMix"+str(Coordinates))
#				newRoomPack = EmptyRooms[floor(rand_range(0,EmptyRooms.size()))]

			var newRoomInstance: = newRoomPack.instance()
			newRoomInstance.position = Coordinates

			Rooms[i][j] = newRoomInstance
			print("new:"+str(Coordinates)+str(Rooms[i][j]))
			# To make sure the player is "Safe" on spawn
			if not (i == 0 and j == 0 ):
				roomHolder.call_deferred("add_child",newRoomInstance)

	emit_signal("FinishedGenInner")


func gen_special_room():
	var coord :=Vector2(floor(rand_range(1,LevelSize.x)) , floor(rand_range(1,LevelSize.y)))
	var newSpecialInstance:InstancePlaceholder=specialRoomPack.instance()
	Rooms[coord.x][coord.y] = newSpecialInstance
	print("Rooms["+str(coord.x)+"]["+str(coord.y)+"]=>"+str(Rooms[coord.x][coord.y]))
	newSpecialInstance.position = Vector2(coord.x,coord.y) * ROOM_SIZE * TileSize

	self.call_deferred("add_child",newSpecialInstance)
	print("Special:"+str(coord)+str(Vector2(coord.x,coord.y) * ROOM_SIZE * TileSize))


func _on_Singleton_generate_again():
	var startpos:= Vector2(1,1) * (ROOM_SIZE * TileSize) / 2
	print("GEnerate again")
	var children = $RoomHolder.get_children()
	for i in $RoomHolder.get_child_count():
#		if children[i].name!="BorderTileMap" and children[i].name!="CanvasLayer" and children[i].name!="PlayerControl":
#			print("kill:"+str(children[i]))
		children[i].queue_free()

	Rooms = create_2d_Array()
#	print(Rooms)
	randomize()
	gen_special_room()
	call_deferred("gen_dungeon_inner_1")

	$PlayerControl/Player.position = startpos
	print($RoomHolder.get_children())


func fixprob():
	var temp1:=probEmpty
	var temp2:=probItem
	var temp3:=probEnemyItem

	probItem = temp1 + temp2
	probEnemyItem = temp1 + temp2 + temp3
	probTotal = probEmpty + probItem + probEnemyItem