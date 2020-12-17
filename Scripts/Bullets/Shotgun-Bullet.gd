extends "res://Scripts/Bullet.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _image = preload("res://Assets/Image/WaterShot_bullet.png")

# Called when the node enters the scene tree for the first time.
func _init(_direction, rotation, _scale).(_direction, rotation, _scale):
	bulletSpeed = 150*_scale;
	bulletSprite.texture = _image
	bulletColliderShape.radius = _image.get_width()/2



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
