extends Node2D

# Item is an inherited template class with functionality that is given to all in game items
class_name Item 

# All items require a type [Weapon][Upgrade][Consumable] etc, replace with the desired type.
var itemType = null

# Unique name for items
var itemName = null
var itemRotateOnCool = false
var itemCooldown : bool = false
var itemCoolTime : float
var itemCoolTimer : Timer = Timer.new()
var itemSprite = null
var itemArea = null
var itemPic = null
var itemRotationOffset = 0
var itemRequiresFlipV = false;
var itemDamage = null;
var itemProjectile = null;
var itemEnd : Vector2 = Vector2(0,0);
var itemPos = Vector2(0,0);
var itemTempRotation = 0

func _init():
	itemSprite = Sprite.new()

	add_child(itemCoolTimer)

	itemArea = Area2D.new()
	itemArea.add_child(CollisionShape2D.new())
	itemArea.get_child(0).shape = RectangleShape2D.new()

	self.add_child(itemArea)
	self.add_child(itemSprite)
	itemSprite.texture = itemPic	

func _ready():
	itemCoolTimer.connect("timeout", self, "resetCooldown")

# Override original get_type so that the new type comes through
static func get_type():
	return "Item"

# useItem is meant to be overridden with the intended effect of an item
func useItem(parent):
	print("WARNING: useItem must be overridden for this item to have use")

# useItemSecondary is an items alternate action also overridden
func useItemSecondary():
	pass

func resetCooldown():
	itemCooldown = false

func cooldown():
	itemCooldown = true
	itemCoolTimer.start(itemCoolTime)

static func vec2deg(normalVectRad : Vector2):
	var tanAns = atan2(normalVectRad.x, normalVectRad.y) + PI/2
	print(tanAns)
	return rad2deg(tanAns)
	
static func deg2vec(angleDeg : float):
	var a = sin(deg2rad(angleDeg))
	var b = cos(deg2rad(angleDeg))
	var c = Vector2(a,b)
	return c

