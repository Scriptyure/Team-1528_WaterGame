# COMMENT FOR JOE: 
#
# I changed the actions called because Up, Right, Down, Left, didn't exist however there are already actions for
# PlayerUp, PlayerDown, PlayerRight, PlayerLeft, so I modified those to have the Player thing on them now, the 
# playerModel wasn't defined so I defined it with a static type of Sprite as well and modified your comment to
# say what the playerModel = get_node() is actually referring to. You might want to look into _input(event) on 
# the docs too however it will make no practical difference so if you don't want to thats also fine.
# BTW: when you refer to the scene tree the path has to start with "/root/" not "root/" just a minor fix.

extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

var player

var playerModel : Sprite

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

func _ready():
	# This gets the Sprite in World Scene for player's model. 
	playerModel = get_node("/root/World/Player/[PH] PlayerModel")




