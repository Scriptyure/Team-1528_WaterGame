extends Node2D

# Item is an inherited template class with functionality that is given to all in game items
class_name Item 

# All items require a type [Weapon][Upgrade][Consumable] etc, replace with the desired type.
var itemType = null

# Unique name for items
var itemName = null

var itemSprite = null
var itemArea = null
var itemPic = null

func _init():
	itemSprite = Sprite.new()

	itemArea = Area2D.new()
	itemArea.add_child(CollisionShape2D.new())
	itemArea.get_child(0).shape = RectangleShape2D.new()

	self.add_child(itemArea)
	self.add_child(itemSprite)
	itemSprite.texture = itemPic
	
# Override original get_type so that the new type comes through
static func get_type():
	return "Item"

# useItem is meant to be overridden with the intended effect of an item
func useItem():
	print("WARNING: useItem must be overridden for this item to have use")

# useItemSecondary is an items alternate action also overridden
func useItemSecondary():
	pass


