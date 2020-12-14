extends "res://Scripts/Inventory/Item.gd"

# Item added to test whether Items can be made easily and efficiently

func _init():
	itemPic = preload("res://Assets/Image/Item-RoboLol.png")
	itemName = "Robot"
	itemSprite.texture = itemPic

func _ready():
	pass # Replace with function body.
