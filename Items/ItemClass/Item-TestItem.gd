extends "res://Scripts/Inventory/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _init():
	._init()
	itemPic = preload("res://Assets/Image/Item-TestItem.png")
	itemName = "TestItem"
	itemSprite.texture = itemPic

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
