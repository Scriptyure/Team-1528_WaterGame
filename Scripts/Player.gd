extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

var playerSpriteLeft : bool = false

var player

onready var playerSprite : AnimatedSprite = get_node("/root/World/Player/PlayerSprite")

# This is the logic behind the controls of the for the player.
func getInput():
	velocity = Vector2()
	if Input.is_action_pressed('PlayerRight'):
		velocity.x += 1
	if Input.is_action_pressed('PlayerLeft'):
		velocity.x -= 1
	if Input.is_action_pressed('PlayerDown'):
		velocity.y += 1
	if Input.is_action_pressed('PlayerUp'):
		velocity.y -= 1
	print(velocity);
	velocity = velocity.normalized() * speed

# This calls the getInput function and provides the logic for the physics.
#_delta is time between frames.
func _physics_process(_delta):
	getInput()
	velocity = move_and_slide(velocity)

func _process(_delta):
	playerSprite.flip_h = playerSpriteLeft;

func _ready():
	pass




