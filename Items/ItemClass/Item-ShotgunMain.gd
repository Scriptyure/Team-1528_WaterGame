extends "res://Scripts/Inventory/Item.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _image = preload("res://Assets/Image/Item-Shotgun.png")
var clicked = false

# Called when the node enters the scene tree for the first time.
func _init():
	itemRequiresFlipV = true
	itemRotationOffset = deg2rad(-90)
	itemName = "ShotgunMain"
	itemPic = _image
	itemSprite.texture = itemPic
	itemEnd = Vector2(16,16)
	print(vec2deg(Vector2(0.707,0.707)))
	print(deg2vec(vec2deg(Vector2(0.707,0.707))))

func _input(e):
	if (Input.is_mouse_button_pressed(BUTTON_LEFT) && clicked):
		pass
	else:
		clicked = false
	
func useItem(parent):
	if !clicked:
		itemPos = parent.playerHeld.get_child(0).global_position
		var mousePos = parent.mousePos
		var mouseAngle = parent.mouseAngle
		var spread = 20;
		var mousePosNorm = vec2deg(mousePos.normalized()) - spread*1.5 + rad2deg(itemRotationOffset)
		print(mousePosNorm)
		for i in range(4):
			var _temp = mousePosNorm + spread*i
			print(str(i) + ": " + str(_temp))
			var bullet = ResourceLoader.load("res://Scripts/Bullets/Shotgun.gd").new(deg2vec(_temp), mouseAngle)
			bullet.global_position = itemPos + itemEnd*mousePos.normalized()
			get_node("/root/World").add_child(bullet)
		clicked = true
	
	

func vec2deg(normalVectRad : Vector2):
	var tanAns = atan2(normalVectRad.x, normalVectRad.y) + PI/2
	print(tanAns)
	return rad2deg(tanAns)

func deg2vec(angleDeg : float):
	var a = sin(deg2rad(angleDeg))
	var b = cos(deg2rad(angleDeg))
	var c = Vector2(a,b)
	return c

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
