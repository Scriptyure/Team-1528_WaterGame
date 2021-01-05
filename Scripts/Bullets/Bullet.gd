extends KinematicBody2D

class_name Bullet

# Reference to the bullets Sprite
var bulletSprite = null

# Bullet scale, effects both Sprite and Collider
var bulletSpriteScale

var bulletEffect = preload("res://Scenes/Effects/BulletEffect.tscn")

# The bullets speed in a direction
var bulletSpeed = 0

# The bullets damage to player or enemy


var bulletCollider : CollisionShape2D 

# The bullets collider shape
var bulletColliderShape = null

# Bullet Rotation offset for sprite to be facing the correct direction
var bulletForwardRotationOffset = 0

# Direction for the bullet to travel in Vector Angles
var bulletDirection = 0

# How long will the bullet exist without hitting something? (In Seconds)
var bulletExistTime = 30.0

# Bullet rotation grabbed from vector direction
var bulletRotation

# Bullets existance timer
var timer : Timer

func _init(_direction : Vector2 , _rotation, _scale):
	bulletDirection = _direction
	bulletColliderShape = CircleShape2D.new()
	bulletColliderShape.radius = 1*_scale;
	bulletCollider = CollisionShape2D.new()
	bulletCollider.shape = bulletColliderShape
	collision_layer = 0b10
	collision_mask = 0b1
	add_child(bulletCollider)
	bulletRotation = vec2deg(_direction)
	bulletSprite = Sprite.new()
	bulletSprite.scale = Vector2(_scale, _scale)
	add_child(bulletSprite)
	timer = Timer.new()
	add_child(timer)

func _ready():
	timer.connect("timeout", self, "destroy", [])
	timer.start(bulletExistTime)
	timer.paused = false;

func destroy():
	var _instance = bulletEffect.instance()
	_instance.position = position - (8*-bulletDirection)
	_instance.rotation = bulletRotation;
	get_node("/root/World").add_child(_instance);
	self.queue_free()
	



func _process(delta : float):	
	bulletSprite.global_rotation = (bulletRotation) + deg2rad(bulletForwardRotationOffset)
	
func _physics_process(delta):
	move_and_slide(bulletDirection*bulletSpeed)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision != null:
			destroy();
	


# --- Helper Functions ---
static func vec2deg(normalVectRad : Vector2):
	var tanAns = atan2(normalVectRad.y,normalVectRad.x) + PI/2
	print(tanAns)
	return tanAns

static func deg2vec(angleDeg : float):
	var a = sin(deg2rad(angleDeg))
	var b = cos(deg2rad(angleDeg))
	var c = Vector2(b,a)
	return -c
