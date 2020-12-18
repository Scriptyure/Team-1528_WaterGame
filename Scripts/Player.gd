
extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

var player

# This is the logic behind the controls of the for the player.
func getInput():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

# This calls the getInput function and provides the logic for the physics.
func physicsProcess(_delta):
	getInput()
	velocity = move_and_slide(velocity)

func _ready():

	# This gets the image that is used for the player model.
	playerModel = get_node("root/World/Player/[PH] PlayerModel")




