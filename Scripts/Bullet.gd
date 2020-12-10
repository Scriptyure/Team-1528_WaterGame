extends KinematicBody2D

class_name Bullet
var bulletSprite = null;

var bulletSpeed = null;
var bulletColliderShape = null;
var forwardRotationOffset = 0;
var bulletDirection = 0;

func _init(_direction : Vector2 , rotation):
	bulletDirection = _direction
	bulletColliderShape = CircleShape2D.new()
	bulletColliderShape.radius = 1;
	bulletSprite = Sprite.new()
	add_child(bulletSprite)



func _process(delta : float):
	
	bulletSprite.rotate(rotation + deg2rad(forwardRotationOffset))
	
func _physics_process(delta):
	move_and_slide(bulletDirection*bulletSpeed)
