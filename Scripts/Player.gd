
extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

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

func physicsProcess(_delta):
	getInput()
	velocity = move_and_slide(velocity)



