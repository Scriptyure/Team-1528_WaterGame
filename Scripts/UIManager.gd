extends Node

var UI_ZINDEX = 500
onready var camera : Camera2D = get_node("/root/World/PlayerCamera")
var UIElements = []
onready var spriteScale = get_node("/root/World/Player/Inv").scaleSpriteAmount
var spriteScaleOffset = 1;

# Horizontal, Vertical
var UIElementPadding = []

# Each element is given an enum
enum UIElementIndex{
	healthElement = 0,
	coinElement = 1,
	ammoCounter = 2,
	perks = 3
}

# Origin anchors
enum UIElementOrigins{
	TopLeft = 0,
	TopRight = 1,
	BottomLeft = 2,
	BottomRight = 3
}

# UIElement base class
class UIElement:
	var _image : Texture
	var _location : Vector2
	var _spriteNode : Sprite
	var _locationOrigin
	func _init(image : Texture, location : Vector2, locationOrigin : int, spriteScale : float):
		_spriteNode = Sprite.new()

		_image = image
		_location = location
		_locationOrigin = locationOrigin

		_spriteNode.texture = _image
		_spriteNode.scale = Vector2(spriteScale, spriteScale)

func _ready():
	var healthElement = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.TopLeft, spriteScale)
	var coinElement = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.TopRight, spriteScale)
	var ammoCounter = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.BottomRight, spriteScale)
	var perks = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.BottomLeft, spriteScale)

	UIElements.resize(UIElementIndex.size())
	UIElements[UIElementIndex.healthElement] = healthElement
	UIElements[UIElementIndex.coinElement] = coinElement
	UIElements[UIElementIndex.ammoCounter] = ammoCounter
	UIElements[UIElementIndex.perks] = perks


func _process(_delta):
	var viewSize = camera.get_viewport().size
	
	updateElementLocation(UIElementIndex.healthElement, Vector2(0,0), viewSize)
	updateElementLocation(UIElementIndex.coinElement, Vector2(0,0), viewSize)
	updateElementLocation(UIElementIndex.ammoCounter, Vector2(0,0), viewSize)
	updateElementLocation(UIElementIndex.perks, Vector2(0,0), viewSize)

	for element in range(UIElements.size()):
		if UIElements[element]._spriteNode.get_parent() != self:
			add_child(UIElements[element]._spriteNode)
		UIElements[element]._spriteNode.z_index = UI_ZINDEX
		UIElements[element]._spriteNode.scale = Vector2(spriteScale,spriteScale)*camera.zoom
		UIElements[element]._spriteNode.position = (Vector2((camera.get_camera_screen_center().x-viewSize.x/2)+UIElements[element]._location.x,(camera.get_camera_screen_center().y - viewSize.y/2)+UIElements[element]._location.y))*camera.zoom


func updateElementImage(element, image : Image):
	UIElements[element]._image = image

# Update element location according to scale and origin anchor
func updateElementLocation(element, location : Vector2, viewSize : Vector2):
	match UIElements[element]._locationOrigin:
		UIElementOrigins.TopLeft:
			UIElements[element]._location = Vector2(0, 0) + Vector2((UIElements[element]._image.get_width()/2*spriteScale)+location.x, ((UIElements[element]._image.get_height()/2)*spriteScale)+location.y)
		UIElementOrigins.TopRight:
			UIElements[element]._location = Vector2(viewSize.x, 0) + Vector2((-(UIElements[element]._image.get_width()/2)*spriteScale)+location.x, ((UIElements[element]._image.get_height()/2)*spriteScale)+location.y)
		UIElementOrigins.BottomLeft:
			UIElements[element]._location = Vector2(0, viewSize.y) + Vector2((UIElements[element]._image.get_width()/2*spriteScale)+location.x, (-(UIElements[element]._image.get_height()/2)*spriteScale)+location.y)
		UIElementOrigins.BottomRight:
			UIElements[element]._location = Vector2(viewSize.x, viewSize.y) + Vector2((-(UIElements[element]._image.get_width()/2)*spriteScale)+location.x, (-(UIElements[element]._image.get_height()/2)*spriteScale)+location.y)
