extends Node

onready var camera : Camera2D = get_node("/root/World/PlayerCamera")
var UIElements = []
var spriteScale = 1

# Horizontal, Vertical
var UIElementPadding = []
enum UIElementIndex{
	healthElement = 0,
	coinElement = 1
}

class UIElement:
	var _image : Texture
	var _location : Vector2
	var _spriteNode : Sprite

	func _init(image : Texture, location : Vector2):
		_spriteNode = Sprite.new()
		_image = image
		_location = location

		_spriteNode.texture = _image
	
	
		
	



func _ready():
	var healthElement = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0))
	var coinElement = UIElement.new(ResourceLoader.load("res://Assets/Image/Health-TestImage.png"), Vector2(0,0))

	UIElements.resize(UIElementIndex.size())
	UIElements[UIElementIndex.healthElement] = healthElement
	UIElements[UIElementIndex.coinElement] = coinElement


func _process(delta):
	var viewSize = camera.get_viewport().size

	updateElementLocation(UIElementIndex.healthElement, Vector2(UIElements[UIElementIndex.healthElement]._image.get_width()/2,UIElements[UIElementIndex.healthElement]._image.get_height()/2))
	updateElementLocation(UIElementIndex.coinElement, Vector2(1000,UIElements[UIElementIndex.coinElement]._image.get_height()/2))

	for element in range(UIElements.size()):
		if UIElements[element]._spriteNode.get_parent() != self:
			add_child(UIElements[element]._spriteNode)
		UIElements[element]._spriteNode.position = Vector2((camera.get_camera_screen_center().x-viewSize.x/2)+UIElements[element]._location.x,(camera.get_camera_screen_center().y - viewSize.y/2)+UIElements[element]._location.y)


func updateElementImage(element, image : Image):
	UIElements[element]._image = image

func updateElementLocation(element, location : Vector2):
		UIElements[element]._location = location
