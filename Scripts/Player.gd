extends KinematicBody2D

export (int) var speed = 1000

var velocity = Vector2()

var playerSpriteLeft : bool = false

var EffectsClass = preload("res://Scripts/Effects/Effects.gd")
var Effects = EffectsClass.new(self)

var player

var playerHealth = 10;

onready var playerSprite : AnimatedSprite = get_node("/root/World/Player/PlayerSprite")

# This is the logic behind the controls of the for the player.
func getInput():
	velocity = Vector2()
	var walking = false

	if Input.is_action_pressed('PlayerRight'):
		velocity.x += 1
		walking = true;
	if Input.is_action_pressed('PlayerLeft'):
		velocity.x -= 1
		walking = true;
	if Input.is_action_pressed('PlayerDown'):
		velocity.y += 1
		walking = true;
	if Input.is_action_pressed('PlayerUp'):
		velocity.y -= 1
		walking = true;
		
	if walking:
		Effects.WalkEffect(Vector2(position.x, position.y+32))
		if playerSprite.animation != "Walk":
			playerSprite.animation = "Walk"
	else:
		playerSprite.animation = "default"

		
	# print(velocity);
	velocity = velocity.normalized() * speed

# This calls the getInput function and provides the logic for the physics.
#_delta is time between frames.
func _physics_process(_delta):
	getInput()
	velocity = move_and_slide(velocity)

func _process(_delta):
	playerSprite.flip_h = playerSpriteLeft;

func _ready():
	add_child(Effects)
	pass

# Player visual effects


# Function for handling health damage
func DamageHealth(amount):
	pass




