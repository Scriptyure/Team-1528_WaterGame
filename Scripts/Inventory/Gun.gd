extends "res://Scripts/Inventory/Item.gd"

# THIS CLASS IS NOT USED CURRENTLY AND MAY NOT BE USED EVER
#
#
#
#

func _ready():
	pass # Replace with function body.


static func vec2deg(normalVectRad : Vector2):
	var tanAns = atan2(normalVectRad.x, normalVectRad.y) + PI/2
	print(tanAns)
	return rad2deg(tanAns)

static func deg2vec(angleDeg : float):
	var a = sin(deg2rad(angleDeg))
	var b = cos(deg2rad(angleDeg))
	var c = Vector2(a,b)
	return c

func calculateFireAngle(parent):
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
