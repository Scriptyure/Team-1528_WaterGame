extends "res://Scripts/Inventory/Item.gd"

# Original TestItem

func _init():
	itemPic = preload("res://Assets/Image/Item-TestItem.png")
	itemName = "TestItem"
	itemSprite.texture = itemPic
	
func _ready():
	pass # Replace with function body.