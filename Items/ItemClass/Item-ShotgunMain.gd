extends "res://Scripts/Inventory/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _image = preload("res://Assets/Image/Item-Shotgun.png")

# Called when the node enters the scene tree for the first time.
func _init():
	itemRequiresFlipV = true
	itemRotationOffset = deg2rad(-90)
	itemName = "ShotgunMain"
	itemPic = _image
	itemSprite.texture = itemPic

func useItem(parent):
	var mousePos = parent.mousePos
	var mouseAngle = parent.mouseAngle
	get_node("/root/World").add_child(ResourceLoader.load("res://Scripts/Bullets/Shotgun.gd").new(mousePos.normalized(), mouseAngle))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
