extends "res://Scripts/Inventory/Item.gd"


var _image = preload("res://Assets/Image/Item-ShotgunWhite.png")
var clicked = false

# Called when the node enters the scene tree for the first time.
func _init():
	itemUseSound = load("res://SoundEffects/shotgun.wav")
	AudioController.stream = itemUseSound
	AudioController.volume_db = -10;
	itemCoolTime = 0.75
	itemRotateOnCoolRate = 360*2.60
	itemRotateOnCool = true
	itemRequiresFlipV = true
	itemRotationOffset = deg2rad(-90)
	itemName = "ShotgunMain"
	itemPic = _image
	itemSprite.texture = itemPic
	itemEnd = Vector2(16,16)

func _input(e):
	if (Input.is_mouse_button_pressed(BUTTON_LEFT) && clicked):
		pass
	else:
		clicked = false

func useItem(parent):
	
	if !clicked && !itemCooldown:
		AudioController.play()
		itemPos = parent.playerHeld.get_child(0).global_position
		var mousePos = parent.mousePos
		var mouseAngle = parent.mouseAngle
		var spread = 20;
		var mousePosNorm = vec2deg(mousePos.normalized()) - spread*1.5 - rad2deg(itemRotationOffset)
		var _itemEnd = itemEnd

		print(mousePosNorm)
		for i in range(4):
			var _temp = mousePosNorm + spread*i
			var bullet = ResourceLoader.load("res://Scripts/Bullets/Shotgun-Bullet.gd").new(deg2vec(_temp), mouseAngle, parent.scaleSpriteAmount)
			bullet.global_position = itemPos + _itemEnd*mousePos.normalized()*parent.scaleSpriteAmount
			get_node("/root/World").add_child(bullet)
		clicked = true
		cooldown()
