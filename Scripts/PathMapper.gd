extends Node

var MapBlock = preload("res://Scripts/MapBlock.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var StartLocation : Vector2
export var CellSize : Vector2
export var MapArea : Vector2

var cells = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(MapArea.y):
		for j in range(MapArea.x):
			cells.append(MapBlock.new(StartLocation+Vector2(j*CellSize.x, i*CellSize.y), CellSize))
			add_child(cells[j+(i*MapArea.x)])
	pass 

# Wrapper to make life a little easier
func getBlock(x,y):
	return cells[x+(y*MapArea.x)]

func getBlockByPosition(x,y):
	pass

