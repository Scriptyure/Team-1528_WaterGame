extends Node2D

# Item is an inherited template class with functionality that is given to all in game items
class_name Item 

# Unique name for items
var itemName = null

#scale the item and its end will be set with
var itemScale = 1

# Rotates the item when cooling down if set true
var itemRotateOnCool = false

# How fast the Item will rotate if itemRotateOnCool is true
var itemRotateOnCoolRate = 0

# A variable used by the Item to know whether it is on cooldown
var itemCooldown : bool = false

# Amount of cooldown time for the object before it is useful again
var itemCoolTime : float

# The Timer object for the Item
var itemCoolTimer : Timer = Timer.new()

# Items Sprite reference
var itemSprite = null

# Items area for pickup purposes
var itemArea = null

# The items texture for Sprite
var itemPic = null

# Rotational Offset for Item when visible
var itemRotationOffset = 0

# Does the Item require to be flipped when the mouse crosses the Y axis?
var itemRequiresFlipV = false;

# Damage value given to Bullet or other classes 
var itemDamage = null;

# What kind of projectile does the item use if any?
var itemProjectile = null;

# End which the items ability will "Shoot" out of 
var itemEnd : Vector2 = Vector2(0,0);

# The items position for local variable handling
var itemPos = Vector2(0,0);

# Item sound
var itemUseSound

# Items sound controller
var AudioController : AudioStreamPlayer2D

# A temporary rotation handler
var itemTempRotation = 0

func _init():
	itemSprite = Sprite.new()
	AudioController = AudioStreamPlayer2D.new()
	add_child(AudioController)
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


# --- Helper Functions ---

static func vec2deg(normalVectRad : Vector2):
	var tanAns = atan2(normalVectRad.y, normalVectRad.x) + PI/2
	print(tanAns)
	return rad2deg(tanAns)
	
static func deg2vec(angleDeg : float):
	var a = sin(deg2rad(angleDeg))
	var b = cos(deg2rad(angleDeg))
	var c = Vector2(b,a)
	return -c

