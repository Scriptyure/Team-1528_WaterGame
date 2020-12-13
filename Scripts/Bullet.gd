extends KinematicBody2D

class_name Bullet

var bulletSprite = null

var bulletSpeed = null
var bulletColliderShape = null
var bulletForwardRotationOffset = 0
var bulletDirection = 0
var bulletExistTime = 30.0
var timer : Timer

func _init(_direction : Vector2 , rotation):
	bulletDirection = _direction
	bulletColliderShape = CircleShape2D.new()
	bulletColliderShape.radius = 1;
	bulletSprite = Sprite.new()
	add_child(bulletSprite)
	timer = Timer.new()
	add_child(timer)

func _ready():
	timer.connect("timeout", self, "destroy", [])
	timer.start(bulletExistTime)
	timer.paused = false;

func destroy():
	self.queue_free()



func _process(delta : float):	
	bulletSprite.rotate(rotation + deg2rad(bulletForwardRotationOffset))
	
func _physics_process(delta):
	move_and_slide(bulletDirection*bulletSpeed)
