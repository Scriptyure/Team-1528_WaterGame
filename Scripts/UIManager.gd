extends Node

onready var camera : Camera2D = get_node("/root/World/PlayerCamera")
var UIElements = []
var spriteScale = 1

# Horizontal, Vertical
var UIElementPadding = []
enum UIElementIndex{
	healthElement = 0,
	coinElement = 1,
	ammoCounter = 2,
	perks = 3
}
enum UIElementOrigins{
	TopLeft = 0,
	TopRight = 1,
	BottomLeft = 2,
	BottomRight = 3
}
class UIElement:
	var _image : Texture
	var _location : Vector2
	var _spriteNode : Sprite
	var _locationOrigin
	func _init(image : Texture, location : Vector2, locationOrigin : int):
		_spriteNode = Sprite.new()
		_image = image
		_location = location
		_locationOrigin = locationOrigin

		_spriteNode.texture = _image
	
	
		
	



func _ready():
	var healthElement = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.TopLeft)
	var coinElement = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.TopRight)
	var ammoCounter = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.BottomRight)
	var perks = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0), UIElementOrigins.BottomLeft)

	UIElements.resize(UIElementIndex.size())
	UIElements[UIElementIndex.healthElement] = healthElement
	UIElements[UIElementIndex.coinElement] = coinElement
	UIElements[UIElementIndex.ammoCounter] = ammoCounter
	UIElements[UIElementIndex.perks] = perks


func _process(delta):
	var viewSize = camera.get_viewport().size

	updateElementLocation(UIElementIndex.healthElement, Vector2(UIElements[UIElementIndex.healthElement]._image.get_width()/2,UIElements[UIElementIndex.healthElement]._image.get_height()/2), viewSize)
	updateElementLocation(UIElementIndex.coinElement, Vector2(-(UIElements[UIElementIndex.coinElement]._image.get_width()/2),UIElements[UIElementIndex.coinElement]._image.get_height()/2), viewSize)
	updateElementLocation(UIElementIndex.ammoCounter, Vector2(-(UIElements[UIElementIndex.ammoCounter]._image.get_width()/2),-(UIElements[UIElementIndex.coinElement]._image.get_height()/2)), viewSize)
	updateElementLocation(UIElementIndex.perks, Vector2(UIElements[UIElementIndex.perks]._image.get_width()/2,-(UIElements[UIElementIndex.coinElement]._image.get_height()/2)), viewSize)

	for element in range(UIElements.size()):
		if UIElements[element]._spriteNode.get_parent() != self:
			add_child(UIElements[element]._spriteNode)
		UIElements[element]._spriteNode.position = Vector2((camera.get_camera_screen_center().x-viewSize.x/2)+UIElements[element]._location.x,(camera.get_camera_screen_center().y - viewSize.y/2)+UIElements[element]._location.y)


func updateElementImage(element, image : Image):
	UIElements[element]._image = image

func updateElementLocation(element, location : Vector2, viewSize : Vector2):
	match UIElements[element]._locationOrigin:
		UIElementOrigins.TopLeft:
			UIElements[element]._location = Vector2(0, 0) + Vector2(location.x, location.y)
		UIElementOrigins.TopRight:
			UIElements[element]._location = Vector2(viewSize.x, 0) + Vector2(location.x, location.y)
		UIElementOrigins.BottomLeft:
			UIElements[element]._location = Vector2(0, viewSize.y) + Vector2(location.x, location.y)
		UIElementOrigins.BottomRight:
			UIElements[element]._location = Vector2(viewSize.x, viewSize.y) + Vector2(location.x, location.y)
